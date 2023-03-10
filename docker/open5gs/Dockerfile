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
# A container for running Open5GS software.
# Source code available at: https://github.com/open5gs/open5gs
# 
# Check the container image for copyright and licenses that apply to the
# included software (/usr/share/doc/*/copyright).
#

FROM debian:bullseye as sources

# Disable interactive mode for apt
ARG DEBIAN_FRONTEND=noninteractive

# Key path
ARG KEY_REP=/usr/share/keyrings/

# Software version (please note that only a limited number of combinations may be possible
ARG OPEN5GS_VERSION="v2.6.1" 

# Install build environment
RUN apt-get update && \
		apt-get -y install python3-pip python3-setuptools python3-wheel ninja-build build-essential flex bison git libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev libnghttp2-dev libmicrohttpd-dev libcurl4-gnutls-dev libnghttp2-dev libtins-dev libtalloc-dev meson cmake 

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
		cp -r install/lib/* /lib/ && \
		cp -r install/var/* /var/ && \
		cp -r install/etc/* /etc/
	
FROM debian:bullseye

RUN if ! [ -d /usr/share/doc/open5gs ]; then mkdir -p /usr/share/doc/open5gs; fi

COPY --from=sources /usr/src/open5gs/install/bin/* /usr/local/bin/
COPY --from=sources /usr/src/open5gs/install/lib/* /lib/
COPY --from=sources /usr/src/open5gs/install/var/* /var/
COPY --from=sources /usr/src/open5gs/install/etc/* /etc/
COPY --from=sources /usr/src/open5gs/debian/copyright /usr/share/doc/open5gs/

ENV TZ="Europe/Rome"

# This part installs testing tools and could be safely removed for "production" releases
RUN apt-get update && \
		apt-get -y install iproute2 tcpdump iputils-ping dnsutils vim procps net-tools
 
WORKDIR /
