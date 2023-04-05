#
# Copyright (C) 2023 Matteo Repetto <mattereppe@gmail.com>
#
# This file is part of the Cloud Native 5G Testbed.
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see:
#
#         https://www.gnu.org/licenses/agpl-3.0.html
#
# This program is provided "as is", WITHOUT ANY WARRANTY; without even the implied 
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. In no event shall
# the authors or copyright holders be liable for any claim, damages or other liability.
# See the License for the specific language governing permissions and limitations
# under the License.
# 

#
# A container for running a mongodb instance.
# Binaries are taken from official software repositories. 
# 
# Check the container image for copyright and licenses that apply to the
# included software (/usr/share/doc/*/copyright).
#
# v1.0.0

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
#RUN apt-get -y install iproute2 tcpdump iputils-ping dnsutils vim procps net-tools

WORKDIR /
