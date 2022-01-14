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
ARG OPEN5GS_VERSION="v2.4.1" # "latest" or a valid repository tag
ARG MONGODB_VERSION=5.0

# Update and install preliminary dependencies
RUN apt-get update; apt-get install -y wget gpg && \
# Add the necessary repositories and keys
		wget -qO - https://www.mongodb.org/static/pgp/server-$MONGODB_VERSION.asc | gpg --dearmor > $KEY_REP/mongodb-org-archive-keyring.gpg && \
	echo "deb [signed-by=$KEY_REP/mongodb-org-archive-keyring.gpg] http://repo.mongodb.org/apt/debian buster/mongodb-org/$MONGODB_VERSION main" | \
		tee /etc/apt/sources.list.d/mongodb-org.list && \
# Install build environment
		apt-get update && \
		apt-get -y install python3-pip python3-setuptools python3-wheel ninja-build build-essential flex bison git libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev libnghttp2-dev libmicrohttpd-dev libcurl4-gnutls-dev libnghttp2-dev libtins-dev libtalloc-dev meson && \
# Install mongodb
		apt-get -y install mongodb-org  
# Install FreeDiameter extensions
RUN apt-get -y install freediameter
COPY config/*pem /etc/freeDiameter/

# Install Open5Gs and its dependencies
RUN cd /usr/src && \
		git clone https://github.com/open5gs/open5gs && \
		cd open5gs && \
		if [ "$OPEN5GS_VERSION" != "latest" ]; then  git checkout tags/$OPEN5GS_VERSION ; fi && \
		meson build --prefix=`pwd`/install && \
		ninja -C build && \
		cd build/ && \
		ninja install && \
		cd .. && \
		cp install/bin/* /usr/local/bin/ && \
		cp -r install/lib/* /usr/local/lib/ && \
		cp -r install/var/* /var/ && \
		mkdir /etc/open5gs/


# This part installs testing tools and could be safely removed for "production" releases
RUN apt-get -y install iproute2 tcpdump iputils-ping dnsutils vim procps net-tools

WORKDIR /
