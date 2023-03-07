# Custome curl image with bash shell
#
# Copyright (c) 2023
#

From curlimages/curl:latest 

# Change to root user to install bash
USER root

RUN apk update && apk upgrade && apk add bash

# Switch back to the non-privileged user
USER curl_user


