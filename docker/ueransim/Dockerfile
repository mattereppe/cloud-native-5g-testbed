# A container for running the UERANSIM gNodeB/UE simulator.
# 
# Copyright (c) 2023, 
#

FROM debian:bullseye as sources

# Software version (please note that only a limited number of combinations may be possible
# ************************************ WARNING ************************************************
# The project is patched for adding routes to the data networks. The patch for the "latest"
# version was done on the following commit, and might not work in case of further updates.
# 1d184a73749634d02f9bc2285fcc0508ff0cbbd9 Tue Oct 25 20:28:52 2022
# Running a tagged version of the software is the safer option.
# *********************************************************************************************
ARG UERANSIM_VERSION="v3.2.6" # "latest" or a valid repository tag

# Install updates and dependencies
RUN apt-get update && apt-get -y upgrade && \
	apt-get -y install make g++ libsctp-dev lksctp-tools  wget git libssl-dev iproute2 && \
	rm -rf /var/lib/apt/lists/* 
# Install recent version of CMake
RUN	version=3.20.1 && \
	cd /usr/src/ && \
	wget https://github.com/Kitware/CMake/releases/download/v$version/cmake-$version.tar.gz && \
	tar xzf cmake-$version.tar.gz && \
	cd cmake-$version &&  \
	./bootstrap && make -j `nproc` && make install && ldconfig 
# Install UERANSIM from sources
COPY ./patches/ueransim-datanetworks-$UERANSIM_VERSION.patch /usr/src/
RUN	cd /usr/src && \
	git clone https://github.com/aligungr/UERANSIM && \
	cd UERANSIM && \
	if [ "$UERANSIM_VERSION" != "latest" ]; then  git checkout $UERANSIM_VERSION ; fi && \
	patch -p1 < ../ueransim-datanetworks-$UERANSIM_VERSION.patch && \
	make 

#FROM debian:bullseye
#
## Copy relevant files
#COPY --from=sources /usr/src/UERANSIM/build/nr-* /usr/local/bin/
#COPY --from=sources /usr/src/UERANSIM/build/libdevbnd.so /usr/local/lib/

RUN cp -a build/nr-* /usr/local/bin/ && cp -a build/libdevbnd.so /usr/local/lib/

RUN mkdir /etc/ueransim
RUN apt-get update && apt-get -y upgrade && \
	apt-get -y install libsctp1 && \
	apt-get -y install iproute2 tcpdump procps iputils-ping dnsutils vim net-tools

RUN echo "Europe/Rome" > /etc/timezone

WORKDIR /usr/local/bin/

