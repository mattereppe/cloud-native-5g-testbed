# A container for running Open5Gs WebUI
# 
# Software is built from sources on GitHub.
#

FROM debian:bullseye

# Disable interactive mode for apt
ARG DEBIAN_FRONTEND=noninteractive

# Software version (please note that only a limited number of combinations may be possible
ARG OPEN5G_VERSION=2.4.1
ARG NODEJS_VERSION=17

# Update and install preliminary dependencies
RUN apt-get update; apt-get install -y curl && \
		curl -fsSL https://deb.nodesource.com/setup_$NODEJS_VERSION.x | bash - && \
		apt-get -y install nodejs && \
# Install Open5Gs WebUI
# The script provided by Open5Gs does not work because it requires MongoDB to be installed in the same
# container. The following instructions have been extracted from the installation script.
		cd /usr/src && \
		curl -sLf 'https://github.com/open5gs/open5gs/archive/v$OPEN5GS_VERSION.tar.gz' | tar zxf - && \
		cd ./open5gs-${OPEN5GS_VERSION}/webui && npm ci --no-optional && npm run build && \
		cd .. && mv webui/ /usr/lib/node_modules/open5gs 

# This part installs testing tools and could be safely removed for "production" releases
RUN apt-get -y install iproute2 tcpdump iputils-ping dnsutils vim procps net-tools

WORKDIR /usr/lib/node_modules/open5gs/
