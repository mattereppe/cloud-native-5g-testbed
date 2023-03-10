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

# Database with 1 subscriber
#COPY mongo-init-1sub /tmp/mongo-init
# Database with 99 subscribers
#COPY mongo-init-99subs /tmp/mongo-init
# Database with 200 subscribers, 100 in the "0000000xxx" range, and 100 in the "1000000xxx" range
COPY mongo-init-200subs /tmp/mongo-init

ENV TZ="Europe/Rome" 

# This part installs testing tools and could be safely removed for "production" releases
RUN apt-get -y install iproute2 tcpdump iputils-ping dnsutils vim procps net-tools

WORKDIR /
