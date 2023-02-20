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
#ARG OPEN5GS_VERSION="v2.2.8" # "latest" or a valid repository tag
#ARG MONGODB_VERSION=5.0
ARG MONGODB_VERSION=6.0

# Update and install preliminary dependencies
RUN apt-get update; apt-get install -y wget gpg && \
# Add the necessary repositories and keys, then install mongodb
		wget -qO - https://www.mongodb.org/static/pgp/server-$MONGODB_VERSION.asc | gpg --dearmor > $KEY_REP/mongodb-org-archive-keyring.gpg && \
	echo "deb [signed-by=$KEY_REP/mongodb-org-archive-keyring.gpg] http://repo.mongodb.org/apt/debian buster/mongodb-org/$MONGODB_VERSION main" | \
		tee /etc/apt/sources.list.d/mongodb-org.list && \
		apt-get update && \
		apt-get -y install mongodb-org  

COPY mongo-init /tmp/mongo-init

RUN mongod --fork --dbpath /srv --logpath /tmp/mongo.log && \
	mongorestore /tmp/mongo-init --drop

RUN echo "Europe/Rome" > /etc/timezone

# This part installs testing tools and could be safely removed for "production" releases
RUN apt-get -y install iproute2 tcpdump iputils-ping dnsutils vim procps net-tools

WORKDIR /
