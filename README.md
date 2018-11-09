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
  necessary RPMs/DEBs needed to generate a basic image

* ister_image.conf: Index of partitions for the image

* packages_list.conf : List of packages and versions (if not specified it will
  take the latest from repository) to install in the image

* localrepo/ : repo data with local deb/rpms

## Output

* linux.img : Image with everything installed and ready to just create a user
  and password 
* linux.iso file : Image to install on VMs or baremetal systems


### Prerequisites

At least have the following development bundles and packages installed

*	[Bundles and Packages for ClearLinux Development](
github.com/clearlinux/clr-bundles/blob/master/bundles/os-clr-on-clr)


Or use the following container:
*	[ClearLinux Container Development](https://hub.docker.com/_/clearlinux/)


<TBD>


## How to build an standard image

* Ubuntu base image:

```
    $ make image OS_KIND=ubuntu
    $ ls image_ubuntu.iso
    $ ls image_ubuntu.img
```

* Centos base image:

```
    $ make image OS_KIND=centos
    $ ls image_centos.iso
    $ ls image_centos.img
```
* CLR base image:

```
    $ make image OS_KIND=clr
    $ ls image_clr.iso
    $ ls image_clr.img
```


## How to build a package

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

The developer needs to copy the src/Makefile.pkg
as Makefile in libvirt/rpm_base/centos:

```
    $ cp src/Makefile.pkg pkgs/libvirt/rpm_base/centos
    $ cd pkgs/libvirt/rpm_base/centos
    $ make OS_KIND=centos
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
    $ make OS_KIND=ubuntu
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

Lets take the example of a Centos base image that we create before and libvirt:

```
    $ cd pkgs/libvirt/rpm_base/centos
    $ make repoadd REPO_PATH=~/repo <if not specified it will use ./repo>
    $ cat packages_list.conf | grep <libvirt> (make sure that your package is
    on the list , the tool will install the runtime dependencies)
    $ make image OS_KIND=centos REPO_PATH=~/repo <if not specified it will use
    ./repo>
    $ ls image_clr.iso
    $ ls image_clr.img
```


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
* **[Felipe Ruiz Garcia](https://github.com/FelipeRuizGarcia)**

## License

This project is licensed under the GNU GPL 2 - see the [LICENSE.md](LICENSE.md) file for details

