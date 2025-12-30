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
# A container for running the UERANSIM gNodeB/UE simulator.
# Source code available at: https://github.com/aligungr/UERANSIM
# 
# Check the container image for copyright and licenses that apply to the
# included software (/usr/share/doc/*/copyright).
#
# v1.0.2

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

FROM debian:bullseye

# Copy relevant files
COPY --from=sources /usr/src/UERANSIM/build/nr-* /usr/local/bin/
COPY --from=sources /usr/src/UERANSIM/build/libdevbnd.so /usr/local/lib/

#RUN cp -a /usr/src/UERANSIM/build/nr-* /usr/local/bin/ && cp -a /usr/src/UERANSIM/build/libdevbnd.so /usr/local/lib/

RUN mkdir /etc/ueransim
RUN apt-get update && apt-get -y upgrade && \
	apt-get -y install libsctp1 iproute2 #&& \
#	apt-get -y install tcpdump procps iputils-ping dnsutils vim net-tools

ENV TZ="Europe/Rome"

WORKDIR /usr/local/bin/

