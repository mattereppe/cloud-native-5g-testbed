# A cloud-native 5G testbed for investigating cyber-threats

This projects provides a Kubernetes application for quick and easy setup of 5G testbeds. The current target is mostly represented by network attacks, but the general structure can be easily extended to cope with other use cases.


# Quick start

- Edit the main configuration and change the values according to your environment:
```
vim config/cn5t.env
```
- Build the configuration and deploy it:
```
make run
```
- Once done, you can remove the application with:
```
make delete
```
- If you want to clean the automatically-generatd manifest files:
```
make clean
```

# Overview of the application

TODO


# Full documentation

Instructions to setup a Kubernetes cluster suitable for this application can be found [here](docs/kubernetes-setup.md).

A more detailed overview of the setup process and configuration options available can be found [here](docs/install.md).

Bugs, limitations, and troubleshooting are available [here](docs/bugs.md).


# License

All templates, scripts, source code and related files including the documentation are  made available under the terms of the GNU Affero General Public License (GNU AGPL v3.0), unless otherwise stated at the beginning of each file.

Running the testbed entails the usage of Docker images. As with all Docker images, these contain other software which may be under different licenses. The list of third parties' software is available in the [repo-info](repo-info/) directory of this project.
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.



