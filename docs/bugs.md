# Known bugs

## Non-cloud native behaviour of UERANSIM

Differently from the 5GC, UERANSIM was only conceived as emulation software to remove the need for real hardware (antennas and UE). Therefore its design is not cloud-native, and this leads to poor integration with the 5GC. Below a short list of the main issues:
- If the AMF changes its address (e.g., it is restarted), GNB does not connect anymore. The current workaround is a liveness probe that checks the list of registered AMFs and reboot the GNB if the list is empty.
- The N3 interface between GNB and UPF is not resilient to changes in the UPF. Similarly to the previous point, if the UPF changes its address (e.g., when restarted), the GNB is not aware of the new address of UPF, and tries to connect to the previous address. The workaround affects the UE in this case, which is restarted in case the tunnel to the UPF does not work.

## Deletering Kubernetes resources

When the cn5gt application is removed from the Kubernetes cluster, errors are likely to occur. The reason is the simple implementation of this operation, which apply the ```delete``` operation on the same merged manifest used for the deployment. This means resources are deleted in the same order as they were created, instead of reverse order as it would be correct. However, this behaviour has not side effect and the whole application namespace is fully deleted.

## Long time to start Goldeneye

It is likely that the goldeneye pod starts before the tunnel to the 5GC is ready, hence resulting in a connection failure. Unfortunately, the ```goldeneye``` software has long timeout in case of connectivity issues (around 2 minutes). Even if our patch and liveness probe guarantee that eventually it is restarted, there is a significant delay before the attack is effective. An additional patch to ```goldeneye``` would be necessary to set shorter timeouts, as done for the ```curl``` client.



# Current limitations

## N6 LAN

The N6 LAN (aka Data Network) is the interface between the 5GC and the external word. It may be the public Internet, or an NFV domain where one or more Network Services are deployed. 

The N6 LAN requires an additional network interface in the UPF pod, which is not a common case for Kubernetes. The current workaround is the definition of an additional [macvlan](https://www.cni.dev/plugins/current/main/macvlan/) network with multus, which however brings several limitations in terms of configuration (i.e., assignment of static/dynamic IP addresses, name resolution, same interface name on all Kubernetes clusters, setup of custom routing rules on different nodes). 

Even if the N6 LAN is expected to be a service chain rather than a plain network link, the current release of cn5gt does not instantiate any pod for this component. Indeed, a single pod will unlikely be enough for running an NFV domain, so this feature is left for future extensions.

## Routing in the UE

UERANSIM sets up a tunnel between the UE and UPF, but does not install any routes to the Data Network. Indeed, it only install a default route in the ```rt_uesimtun0``` routing table, and a rule that uses such table only for traffic originated by the tunnel interface (i.e., ```uesimtun0```). This is an issue when building a real use-case, because not every software allows to select a specific interface to bind to. Most examples of existing deployment just shows a simple example that varifies connectivity, but is of limited practical interest:
```
ping -I uesimtun0 10.45.0.1
```

The current workaround consists in a patch for UERANSIM that sets up a route to the Data Network after the tunnel has been created. Since the Data Network address is not the same of the tunnel, this information must be explicitely configured. A better solution would be to include it in the tunnel configuration process, but this requires deeper analysis of the Open5GS implementation.


## UERANSIM versions

Given the need for a patch, only the latest UERANSIM release is currently supported. This is not a major issue, because usually the latest version is the most complete and stable. However, the UERANSIM software is no longer maintained by its original developers, and this will likely become an issue in the long-term.

## Single Internet server

A single instance of the Internet server can be run. This limitation is only due to the ```multus``` Data Network and the difficulty to manage in a simple way IP addresses for that network without a mechanism to automatically register them in the cluster database.

## Persistent storage

Persistent storage is needed to keep network configuration (mostly registration of users) across multiple deployments. Unfortunately, there is not a single way to provide persistent storage in Kubernetes. The current implementation use a Network File System (NFS) volume because it is the simpler and quicker solution to setup, but this solution limits the portability to different environments and the time to set up the use case in a new cluster.  A possible workaround would be to use volatile storage and embed the database in the docker image, as it already happens in case of initialization. 

## NET_ADMIN capability

Some pods require the NET_ADMIN capability to be run (UPF, UE, Internet Server). This might be unpleasant for some users, but it is necessary to setup IP addresses and network routes.  
