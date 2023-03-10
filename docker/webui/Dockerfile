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
# A container for running the web interface of the Open5GS software.
# Source code available at: https://github.com/open5gs/open5gs
# 
# Check the container image for copyright and licenses that apply to the
# included software (/usr/share/doc/*/copyright).
#

FROM debian:bullseye as sources

# Disable interactive mode for apt
ARG DEBIAN_FRONTEND=noninteractive

# Software version. Can be "git" (for the latest version) or "x.y.z" for an archived version.
#ARG OPEN5GS_VERSION="2.4.14"
#ARG NODEJS_VERSION="17"
ARG OPEN5GS_VERSION="2.6.1"
ARG NODEJS_VERSION="19"

# Update and install preliminary dependencies
RUN apt-get update; apt-get install -y wget curl git && \
# Install Nodejs
   curl -fsSL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash - && \ 
	apt-get install -y nodejs && \
# Install Open5Gs WebUI
	cd /usr/src/ && \
	if [ "$OPEN5GS_VERSION" = "git" ]; then \
	  mkdir ./open5gs; \
	  cd /open5gs; \
	  git clone https://github.com/open5gs/open5gs.git . ;	\
	else \
		wget -qO- /dev/null "https://github.com/open5gs/open5gs/archive/v${OPEN5GS_VERSION}.tar.gz" | tar zxf - ; \
		mv open5gs-$OPEN5GS_VERSION open5gs; \
	fi && \
	cd /usr/src/open5gs/webui/ && \
	npm ci --no-optional && npm run build 
#	&& \
#	if [ ! -d /usr/lib/node_modules ]; then mkdir /usr/lib/node_modules; fi && \
#	if [ -d /usr/lib/node_modules/open5gs ]; then rm -rf /usr/lib/node_modules/open5gs; fi && \
#	mv /usr/src/open5gs/webui /usr/lib/node_modules/open5gs && \
#	rm -rf /usr/src/open5gs

FROM debian:bullseye

RUN if [ ! -d /usr/lib/node_modules ]; then mkdir /usr/lib/node_modules; fi 

COPY --from=sources /usr/src/open5gs/webui /usr/lib/node_modules/open5gs

RUN apt-get update
# This part installs testing tools and could be safely removed for "production" releases
RUN apt-get -y install iproute2 tcpdump iputils-ping dnsutils vim procps net-tools

ENV TZ="Europe/Rome"

WORKDIR /usr/lib/node_modules/open5gs/

CMD npm run start

EXPOSE 3000
