# A container for running the UERANSIM gNodeB/UE simulator.
# 
# Copyright (c) 2021, The ASTRID Consortium
# All rights reserved.
#

FROM debian:bullseye as sources

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
RUN	cd /usr/src && \
	git clone https://github.com/aligungr/UERANSIM && \
	cd UERANSIM && \
	make &&  \
#	mv build/nr-* /usr/local/bin/ && \
#	mv build/libdevbnd.so /usr/local/lib/ && \
#	mkdir /etc/ueransim && \
# Purge unnecessary files
	cd /usr/src/cmake-$version && \
	make uninstall && \
	apt-get -y purge make g++ wget git libssl-dev && \ 
	apt-get -y autoremove && \
	rm -rf /usr/src/cmake* && \
	rm -rf /usr/src/UERANSIM

FROM debian:bullseye

# Copy relevant files
COPY --from=sources /usr/src/UERANSIM/build/nr-* /usr/local/bin
COPY --from=sources /usr/src/UERANSIM/libdevbnd.so /usr/local/lib

RUN mkdir /etc/ueransim
RUN apt-get update && apt-get -y upgrade && \
	apt-get -y install iproute2 tcpdump procps iputils-ping dnsutils vim net-tools

WORKDIR /usr/local/bin/

