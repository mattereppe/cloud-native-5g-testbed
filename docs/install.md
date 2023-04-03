# Install the 5G Kubernetes application

This guide describes the full process for setting up a working instance of the 5G application, including its use-cases.


# Prerequisites

The main prerequisite to run the testbed is a Kubernetes installation. If you haven't got a cluster, you can follow the instructions [here](docs/kubernetes-setup.md) to install a working environment for this application.

There are a few conditions for the setup to work correctly:
- all Kubernetes nodes must have an interface with the same name connected to a working network (this is typically the cluster network, but it could also be an additional network);
- an NFS server for exporting a folder to all nodes (default: /srv/mongodb);
- envsubst installed in your building machine;
- flannel cni for the cluster network; other cnis might work but have not been tested yet.

# 
