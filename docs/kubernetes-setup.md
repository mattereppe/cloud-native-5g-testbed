# Installing a Kubernetes cluster

This is a quick tutorial to install a minimal Kubernetes cluster on physical servers or VMs. This is not intended to be a detailed guide to Kubernetes; it just includes the necessary steps to setup an environment suitable to run the cn5gt application.

## Prerequisites

A working Linux installation is required to setup the cluster, on at least 2 servers/VMs.
The following instructions assume a Debian-based distribution.

## Install Kubernetes packages

Make sure to install the following packages and their dependencies (older versions might work as well, but have not been tested):
- kubeadm, kubectl, kubelet (>=1.26.1)
- kubernetes-cni (>=1.2.0)
- docker-ce, docker-ce-cli (>=23.0.1)
- containerd.io (>=1.6.15)

On Debian, the following steps can be followed to install these packages:
```
curl -fsSLo /etc/apt/trusted.gpg.d/docker-archive.gpg https://download.docker.com/linux/debian/gpg
echo "deb https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list
apt-get install containerd.io docker-ce docker-ce-cli

for docker packages, and
```
curl -fsSLo /etc/apt/trusted.gpg.d/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
apt-get install kubeadm kubectl kubelet 
```
for Kubernetes.

Be careful that Kubernetes v1.26 deprecated CRI v1alpha2 API and containerd 1.5 support. This means that containerd version 1.5 and older  are not supported in Kubernetes 1.26. Containerd must be upgraded **before** installing Kubernetes 1.26. However, it is possible that the older API is still used, if the following containerd configuration is not applied:
```
[/etc/containerd/config.toml]
version = 2
[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
   [plugins."io.containerd.grpc.v1.cri".containerd]
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true
```
Also check to comment this line in the same file:
```
#disabled_plugins = ["cri"]
```

Once all of these services are successfully started, the cluster configuration can be initiated.

## Configure the master node

### Create the cluster

Create the cluster with the following command:
```
kubeadm init --pod-network-cidr <netaddress/prefix> --service-cidr=<netaddress/prefix> --apiserver-cert-extra-sans=<server IP address list>  --service-dns-domain=<domainname>
```

The ```--pod-network-cidr``` and ```--service-cidr``` paramters can be omitted if the default values are ok for your installation. 
The ```--apiserver-cert-extra-sans``` should be used when your installation is behind a NAT, and should include both the private and public IP address used to access the cluster from the internal and external network, respectively.
The ``--service-dns-domain``` allows to select a domain name different than the default one (e.g., it may be a subdomain of your main domain, which allows to solve service name from external hosts).

Mind the command reported at the end of the installation, which will be used to join the worker nodes.

### Add the network CNI

The simplest CNI for building a distributed cluster is flannel. If the default pod-network-cidr network was used to create the cluster in the previous step, no change to its manifest file are necessary. The installation is a simple one-liner:
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
Otherwise, you need to download the file and change the network address. Download the yml file:
```
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
and replace the default value with the subnet used at the previous step:
```
data:
...
   net-conf.json: |
     {
       "Network": "<netaddress/prefix",
       "Backend": {
         "Type": "vxlan"
       }
     }
```
Finally, deploy flannel:
```
kubectl -f kube-flannel.yml
```


### Check connectivity

Check that the default forwarding policy is ACCEPT: (see this [bug](https://github.com/kubernetes/kops/issues/3958)):
```
iptables -t filter -L
```
In case it is set to deny, change it for the cluster network:
```
iptables -A FORWARD -s <clusterCIDR> -j ACCEPT
iptables -A FORWARD -d <clusterCIDR> -j ACCEPT
```

If you are deploying in OpenStack, check that anti-spoofing filters do not prevent communication between Kubernetes pod. In case, 
	- either disable port security on all VMs:
	- or add the subnet of pod address to the set of allowed networks:
	```
	openstack port set  --allowed-address ip-address=<clusterCIDR> <port id>
	```



## Configure worker nodes

Follows the same instructions to setup the Kubernetes packages on each worker node as [previously](Install-Kubernetes-packages) described.

Run the command returned at the end of the [cluster installation](). If you didn't take note of the command, or the token is no more valid, you can generate it again by running the following command on the master node:
```
kubeadm token create --print-join-command
```

## Add role to workers (optional)

By default, only the control plane has an assigned role (it seems to be a long-standing bug in kubernetes). The role is just a label that can be added with:
```
kubectl label node kube1 node-role.kubernetes.io/worker=worker
```

## Make the master node a worker

By default, no workload is scheduled on the master node. If you want to broaden the set of workers (or in case you have only a single VM/server avaialble), you can taint that master:
```
kubectl taint nodes <master-node id> node-role.kubernetes.io/control-plane-
```

