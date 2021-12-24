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
RUN apt-get update; apt-get install -y wget gpg 
# Add the necessary repositories and keys

WORKDIR /
