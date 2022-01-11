# A container for running Open5Gs WebUI
# 
# Software is built from sources on GitHub.
#

FROM debian:bullseye

# Disable interactive mode for apt
ARG DEBIAN_FRONTEND=noninteractive

# Software version. Can be "git" (for the latest version) or "x.y.z" for an archived version.
ARG OPEN5GS_VERSION="2.4.1"
ARG NODEJS_VERSION="17"

# Update and install preliminary dependencies
RUN apt-get update; apt-get install -y wget curl git && \
# Install Nodejs
   curl -fsSL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash - && \ 
	apt-get install -y nodejs && \
# Install Open5Gs WebUI
	cd /usr/src/ && \
	if [ "$OPEN5GS_VERSION" = "git" ]; then \
	  mkdir ./open5gs-$OPEN5GS_VERSION; \
	  cd /open5gs-$OPEN5GS_VERSION; \
	  git clone https://github.com/open5gs/open5gs.git . ;	\
	else \
		wget -qO- /dev/null "https://github.com/open5gs/open5gs/archive/v${OPEN5GS_VERSION}.tar.gz" | tar zxf - ; \
	fi && \
	cd /usr/src/open5gs-$OPEN5GS_VERSION/webui/ && \
	npm ci --no-optional && npm run build && \
	if [ ! -d /usr/lib/node_modules ]; then mkdir /usr/lib/node_modules; fi && \
	if [ -d /usr/lib/node_modules/open5gs ]; then rm -rf /usr/lib/node_modules/open5gs; fi && \
	mv /usr/src/open5gs-$OPEN5GS_VERSION/webui /usr/lib/node_modules/open5gs && \
	rm -rf /usr/src/open5gs-$OPEN5GS_VERSION

# This part installs testing tools and could be safely removed for "production" releases
RUN apt-get -y install iproute2 tcpdump iputils-ping dnsutils vim procps net-tools

WORKDIR /usr/lib/node_modules/open5gs/

CMD npm run start

EXPOSE 3000
