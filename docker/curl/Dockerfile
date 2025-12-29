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
# Custome curl Docker image with bash shell
# Base Docker image from: https://hub.docker.com/r/curlimages/curl
# 
# Check the container image for copyright and licenses that apply to the
# included software (/usr/share/doc/*/copyright).
#
# v1.0.0

From curlimages/curl:latest 

# Change to root user to install bash
USER root

RUN apk update && apk upgrade && apk add bash coreutils tzdata
ENV TZ="Europe/Rome"

# Switch back to the non-privileged user
USER curl_user


