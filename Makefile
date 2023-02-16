# Build a single Kubernetes deployment files for running Open5Gs and emulated
# RAN/UE with UERANSIM.

# Paths and filenames
DEPLOY_DIR := deploy
BUILD_DIR := build
CONFIG_DIR := config
TEMPLATE_DIR := templates
K8S_DEPLOY_FILE := $(DEPLOY_DIR)/open5gs.yaml
ENV_FILE := open5gs.env

# Load the configuration file as environment variables
include  $(CONFIG_DIR)/$(ENV_FILE)
export
# Note: it is necessary to explicitly list all variables to be replaced, because there are
# additional variables that will be replaced at deployment time.
ENV_VARS := $(shell grep -v '^\#' $(CONFIG_DIR)/$(ENV_FILE) | sed -e 's/\(.*\)/$$\1/' | cut -d '=' -f1 | xargs )

# Dependencies
TEMPLATE := $(wildcard $(TEMPLATE_DIR)/*/*/*.yaml) 
DEPLOY := $(subst $(TEMPLATE_DIR),$(DEPLOY_DIR),$(TEMPLATE))

all: $(K8S_DEPLOY_FILE)

.PHONY: clean config deploy-clean help deploy

help:
	@echo "Cloud-native 5G deployment"
	@echo "=========================="
	@echo "config:       Create initial configuration tailored to current environment"
	@echo "              (setup your environment variables before building this target"
	@echo "install:      Install yaml files for deployment. Do not change existing deployment"
	@echo "deploy:       Prepare a single deployment file for the 5G testbed"
	@echo "run:          Run the 5G testbed"
	@echo "all:          Create K8S deployment file"
	@echo "clean:        Remove build files. Do not touch current deployment files"
	@echo "deploy-clean: Remove all deployment files"
	@echo "deepclean:    Remove any file generated by this Makefile. USE WITH CAUTION!!!"

clean:
	rm -rf $(BUILD_DIR)/*

deploy-clean:
	rm -rf $(DEPLOY_DIR)/*

deepclean: clean deploy-clean

$(BUILD_DIR)/%.yaml: 
	@echo "Creating: " $@
	@test -d `dirname $@` || mkdir -p `dirname $@`
	@envsubst '$(ENV_VARS)' < $(subst $(BUILD_DIR),$(TEMPLATE_DIR),$@) > $@

config: $(subst $(TEMPLATE_DIR),$(BUILD_DIR),$(TEMPLATE))
	@echo "Configuration completed!"

$(DEPLOY_DIR)/%.yaml: $(BUILD_DIR)/%.yaml
	@echo "Installing: " $@
	@test -d `dirname $@` || mkdir -p `dirname $@`
	@install $(subst $(DEPLOY_DIR),$(BUILD_DIR),$@) $@

install: $(subst $(TEMPLATE_DIR),$(DEPLOY_DIR),$(TEMPLATE))
	@echo "Configuration installed!"

$(K8S_DEPLOY_FILE): $(DEPLOY) Makefile
	@echo "---" > $(K8S_DEPLOY_FILE)
	@for file in $(DEPLOY_DIR)/*/*/*; do \
		echo "Merging: " $$file; \
		cat $$file >> $(K8S_DEPLOY_FILE); \
		echo "---" >> $(K8S_DEPLOY_FILE); \
	done

deploy: $(K8S_DEPLOY_FILE)
	@echo "-----"
	@echo "Done. "
	@echo "-----"
	@echo "To create/update the Open5Gs service run: \"kubectl apply -f $(K8S_DEPLOY_FILE)\"."
	@echo "To remove the service, run: \"kubectl delete -f $(K8S_DEPLOY_FILE)\"."

run: $(K8S_DEPLOY_FILE)
	kubectl apply -f $<
