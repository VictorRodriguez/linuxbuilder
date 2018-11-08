# linuxbuilder

Create a Linux image based on multiple OS flavors (Centos,ClearLinux,Fedora,LFS). This project is intented for anyone that wants to build a Linux Image (img/iso/kvm/cloud) based on RPMs. 

The reason for this project is if you want to create your own custumized distribution do not pass for all the nightmare of make it with a simple command line. 

## Inputs

The input are either: 

* Remote/Local RPM repository: Point where the tool will consume all the necesary RPMs needed to generate a baisc image 
* Ister config file: Partitions generated for the image
* Packages config file : List of packages and versions (if not specified witll take the latest) to install in the image

## Output

* linux.img : Image with everything installed and ready to just create a user and password 
* linux.iso file : Image to install on VMs or baremetal systems


## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

If you are developing in a Linux system you can use the following container: 

Or install the following basic packges: 
https://github.com/clearlinux/clr-bundles/blob/master/bundles/os-clr-on-clr


### Prerequisites

At least have the following development packages installed 

https://github.com/clearlinux/clr-bundles/blob/master/bundles/os-clr-on-clr

Or use the following contianer: 

<TBD>


## How to build an image

## How to buidl a pacakge

Imagine that you have the following repository: 

```
libvirt/
├── deb_base
│   └── ubuntu
│       ├── patches
│       │   └── cve_fix.patch
│       └── rules
└── rpm_base
    ├── centos
    │   ├── cve_fix.patch
    │   ├── improve_perf.patch
    │   └── libvrit.spec
    ├── clr
    │   └── cve_fix.patch
    └── fedora
        └── cve_fix.patch

```

The developer needs to  copy the src/Makefile.pkg
as Makefile in libvirt/rpm_base/centos:


```
    $ cp src/Makefile.pkg pkgs/libvirt/rpm_base/centos
    $ cd pkgs/libvirt/rpm_base/centos
    $ make make OS_KIND=centos
```
This will generate a RPMs under:

```
    libvirt/rpm_base/centos/rpms 
```

and log files under:

```
    libvirt/rpm_base/centos/logs
```

Same thing for debian base, developer can just run 

```
    $ cd libvirt/rpm_base/ubuntu
    $ make make OS_KIND=ubuntu
```
This will generate DEBs under:

```
    libvirt/deb_base/ubuntu/debs
```

and log files under:

```
    libvirt/deb_base/ubuntu/logs
```

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Victor Rodriguez** - *initial work* - [purplebooth](https://github.com/VictorRodriguez)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the GNU GPL 2 - see the [LICENSE.md](LICENSE.md) file for details

