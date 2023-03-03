# Build a single Kubernetes deployment files for running Open5Gs and emulated
# RAN/UE with UERANSIM.

# Paths and filenames
DEPLOY_DIR := deploy
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

# Automatically derive prefix from the network address
PREFIX := $(shell echo $(DATANETWORK1) | cut -d "/" -f2)
UPFADDR := $(UEGW)/$(PREFIX)
ENV_VARS += $$UPFADDR

# Dependencies
TEMPLATE := $(wildcard $(TEMPLATE_DIR)/*/*/*.yaml) 
DEPLOY := $(subst $(TEMPLATE_DIR),$(DEPLOY_DIR),$(TEMPLATE))

.PHONY: all clean help config 

all: $(K8S_DEPLOY_FILE) config

help:
	@echo "Cloud-native 5G deployment"
	@echo "=========================="
	@echo "config:       Create initial configuration tailored to current environment"
	@echo "              (setup your environment variables before building this target"
	@echo "all:          Create single K8S deployment file"
	@echo "run:          Run the 5G testbed"
	@echo "delete:       Delete K8S resources of the 5G testebed"
	@echo "clean:        Remove build files. Do not touch current deployment files"


clean:
	rm -rf $(DEPLOY_DIR)/*

config: $(DEPLOY) 

$(DEPLOY_DIR)/%.yaml: $(TEMPLATE_DIR)/%.yaml $(CONFIG_DIR)/$(ENV_FILE)
	@echo "Creating: " $@
	@test -d `dirname $@` || mkdir -p `dirname $@`
	@envsubst '$(ENV_VARS)' < $(subst $(DEPLOY_DIR),$(TEMPLATE_DIR),$@) > $@

$(K8S_DEPLOY_FILE): $(DEPLOY) 
	@echo "---" > $(K8S_DEPLOY_FILE)
	@for file in $(DEPLOY_DIR)/*/*/*; do \
		echo "Merging: " $$file; \
		cat $$file >> $(K8S_DEPLOY_FILE); \
		echo "---" >> $(K8S_DEPLOY_FILE); \
	done
	@echo "Done. "
	@echo "-----"
	@echo "To create/update the Open5Gs service run: \"kubectl apply -f $(K8S_DEPLOY_FILE)\"."
	@echo "To remove the service, run: \"kubectl delete -f $(K8S_DEPLOY_FILE)\"."

run: $(K8S_DEPLOY_FILE)
	kubectl apply -f $<

delete: $(K8S_DEPLOY_FILE)
	kubectl delete -f $<
