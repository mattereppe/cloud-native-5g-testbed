# A container for running Open5Gs 
# 
# Binaries are taken from official software repositories.
#

FROM debian:bullseye

# Add the necessary repositories and keys
RUN echo "deb http://download.opensuse.org/repositories/home:/acetcom:/open5gs:/latest/Debian_10/ ./" | \ 
		tee /etc/apt/sources.list.d/open5gs.list && \
	echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | \
		tee /etc/apt/sources.list.d/mongodb-org.list && \
		wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add - # FIXME!!!
		wget -qO - https://download.opensuse.org/repositories/home:/acetcom:/open5gs:/latest/Debian_10/Release.key |  apt-key add - # FIXME!!!
# Install Open5Gs and its dependencies

CMD /bin/bash
