# linuxbuilder

Linuxbuilder helps you to create a Linux image based on multiple OS flavors
(Centos,ClearLinux,Fedora,LFS,debian).
This project is intented for anyone that wants
to build a Linux Image (img/iso/kvm/cloud) based on RPMs and DEBs. 

We create this project to avoid the nightmare of create your own tools/scripts
for the creation of your customized distribution,
this project provide the tools to do that
with a simple command line (Make).

## Inputs

The input are either: 

* remote_repository.conf: Point where the tool will consume all the
  necessary RPMs/DEBs needed to generate a basic image(WIP)

* ister_image.conf: Index of partitions for the image(WIP)

* packages_list.conf : List of packages and versions (if not specified it will
  take the latest from repository) to install in the images


## Output

* ubuntu.iso : Image to install unattended Ubuntu with the deb packages from
DEBS directory.

* centos.iso file : Image to install on unattended CentOS with the RPMs from
RPMS directory.


### Prerequisites

At least have the following development bundles and packages installed

*	[Bundles and Packages for ClearLinux Development](
github.com/clearlinux/clr-bundles/blob/master/bundles/os-clr-on-clr)


Or use the following container:
*	[ClearLinux Container Development](https://hub.docker.com/_/clearlinux/)


<TBD>


## How to build an standard image

* Ubuntu base image:

```bash cp $YOUR_DEBS DEBS
$ curl -O http://releases.ubuntu.com/16.04/ubuntu-16.04.5-server-amd64.iso
$ make iso-ubuntu
```
* CentOS base image:

```bash cp $YOUR_RPMS RPMS
$ curl -O http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1804.iso
$ make iso-centos
```

* CLR base image: (WIP)

```bash
    $ make image OS_KIND=clr
    $ ls image_clr.iso
    $ ls image_clr.img
```

## How to build a package (WIP)

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

The developer needs to execute:

```
    $ ln -s $PWD/Makefile.toplevel $YOUR_PKG_PATH/Makefile
    $ cd YOUR_PKG_PATH
    $ DIST_NAME=centos make build-rpm
```

This will generate a RPMs and logs under:

```
    libvirt/rpm_base/centos/results
```

Same thing for debian base, developer can just run 

```
    $ cd libvirt/rpm_base/ubuntu
```
This will generate DEBs under:

```
    libvirt/deb_base/ubuntu/debs
```

and log files under:

```
    libvirt/deb_base/ubuntu/logs
```

## How to build a custome image:

## Contributing

Please read
[CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426)
for details on our code of conduct,
and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning.
For the versions available, see the
[tags on this repository](github.com/VictorRodriguez/linuxbuilder/tags).

## Authors

* **[VictorRodriguez](https://github.com/VictorRodriguez)** - *initial work*
* **[JesusOrnelas](https://github.com/chuyd)** - *initial work*
* **[Felipe Ruiz Garcia](https://github.com/FelipeRuizGarcia)**

## License

This project is licensed under the GNU GPL 2 - see the [LICENSE.md](LICENSE.md) file for details

