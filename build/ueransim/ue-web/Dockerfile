# A container for running the UERANSIM UE simulator.
# 
# Copyright (c) 2021, The ASTRID Consortium
# All rights reserved.
#

FROM ueransim/base:3.1.9


ENV PATH=/usr/local/bin:$PATH
ENV DATANET="10.45.0.0/16"
ENV UESIMIFACE="uesimtun0"

# Install python libraries for flask
RUN apt-get update && apt-get -y upgrade && \
	apt-get install -y python3-flask python3-flask-api python3-yaml python3-pyroute2 && \
	rm -rf /var/lib/apt/lists/* 
COPY app.py /root/
COPY UERanSim.py /root/
	
# Add the configuration file for UE
COPY open5gs-ue.yaml /etc/ueransim/
COPY defaults /etc/default/ueransim

# Add the wrapper for initialization
COPY run-ue.sh /usr/local/bin/

# Expose the standard port 
# (should be changed at runtime if a different
# value is present in the environment.
#EXPOSE 53717/udp
#EXPOSE 2152/udp

WORKDIR /root/

ENTRYPOINT ["run-ue.sh"]

CMD ["python3","app.py"]

