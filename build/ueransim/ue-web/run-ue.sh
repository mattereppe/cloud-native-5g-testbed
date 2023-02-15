#!/bin/bash
set -e

# List of variables managed for this configuration file
variables="MCC MNC GNB_IP UEIMSI UEKEY UEOP UEIMEISV UEIMEI UEAMF SST SD WEB_MGMT_PORT"

# Get IP address for this instance.
# Warning: this only works for simple containers with a single network
# interface and no IPv6 support.
UE_IP=$(awk 'END{print $1}' /etc/hosts)

if test -f /etc/default/ueransim; then
	. /etc/default/ueransim

	# Use default values for variables not instantiated at runtime
	for var in $variables; do
		if [ -z ${!var} ]; then
			default=d$var
			eval "$var"=${!default}
		fi
	done
	
	# Update the configuration file/app
	for var in $variables; do
		sed -ie "s/$var/${!var}/g" /etc/ueransim/open5gs-ue.yaml
		sed -ie "s/$var/${!var}/g" /root/app.py
	done
	
fi

echo "Current ue settings: "
for var in $variables; do
	echo $var ": " ${!var}
done
echo 

exec $@


