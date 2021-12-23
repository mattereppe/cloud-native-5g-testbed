# A container for running Open5Gs 
# 
# Binaries are taken from official software repositories.
#

FROM debian:bullseye

# Disable interactive mode for apt
ARG DEBIAN_FRONTEND=noninteractive

# Key path
ARG KEY_REP=/usr/share/keyrings/

# Software version (please note that only a limited number of combinations may be possible
ARG OPEN5G_DEBIAN=Debian_10
ARG OPEN5G_VERSION=latest
ARG MONGODB_VERSION=5.0

# Update and install preliminary dependencies
RUN apt-get update; apt-get install -y wget gpg && \
# Add the necessary repositories and keys
		wget -qO - https://www.mongodb.org/static/pgp/server-$MONGODB_VERSION.asc | gpg --dearmor > $KEY_REP/mongodb-org-archive-keyring.gpg && \
		wget -qO - https://download.opensuse.org/repositories/home:/acetcom:/open5gs:/$OPEN5G_VERSION/$OPEN5G_DEBIAN/Release.key |  \ 
			gpg --dearmor > $KEY_REP/open5gs-archive-keyring.gpg && \
	echo "deb [signed-by=$KEY_REP/open5gs-archive-keyring.gpg] http://download.opensuse.org/repositories/home:/acetcom:/open5gs:/$OPEN5G_VERSION/$OPEN5G_DEBIAN/ ./" | \ 
		tee /etc/apt/sources.list.d/open5gs.list && \
	echo "deb [signed-by=$KEY_REP/mongodb-org-archive-keyring.gpg] http://repo.mongodb.org/apt/debian buster/mongodb-org/$MONGODB_VERSION main" | \
		tee /etc/apt/sources.list.d/mongodb-org.list && \
# Install Open5Gs and its dependencies
		apt-get update && apt-get -y install mongodb-org open5gs 

# This part installs testing tools and could be safely removed for "production" releases
RUN apt-get -y install iproute2 tcpdump iputils-ping dnsutils vim procps net-tools

WORKDIR /
