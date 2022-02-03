# SDR Docker Base Image

## Purpose

Provide a basic image, with all normal packages common to all installs of [mikenye](https://github.com/mikenye/), [fredclausen](https://github.com/fredclausen), or [kx1t](https://github.com/kx1t/) SDR docker images, to reduce download time and disk space usage for users.

## Adding containers

1) Create your new docker file
2) [Update github actions](Add-New-Container-Template.MD)
3) Update the [Tags](#tags) section
4) Update the [Projects and Tag Tree](#Projects-and-Tag-Tree) section

## Tags

| Tag | Extends | Included Packages |
| --- | ------- | ------------------|
| `base` | - | [s6-overlay](https://github.com/just-containers/s6-overlay) (via [mikenye/deploy-s6-overlay](https://github.com/mikenye/deploy-s6-overlay)), [mikenye/docker-healthchecks-framework](https://github.com/mikenye/docker-healthchecks-framework), [bc](https://packages.debian.org/stable/bc), [ca-certificates](https://packages.debian.org/stable/ca-certificates), [curl](https://packages.debian.org/stable/curl), [gawk](https://packages.debian.org/stable/gawk), [ncat](https://packages.debian.org/stable/ncat), [net-tools](https://packages.debian.org/stable/net-tools), [procps](https://packages.debian.org/stable/procps), [socat](https://packages.debian.org/stable/socat) |
| `acars-decoder` | `rtlsdr` | [libacars](https://github.com/szpajder/libacars) and all prerequisites for full functionality: ([zlib1g](https://packages.debian.org/stable/zlib1g), [libxml2](https://packages.debian.org/stable/zlib1g), [libsqlite3](https://packages.debian.org/stable/libsqlite3)) |
| `python` | `base` | [python3](https://packages.debian.org/stable/python3), [python3-pip](https://packages.debian.org/stable/python3-pip), [python3-setuptools](https://packages.debian.org/stable/python3-setuptools), [python3-wheel](https://packages.debian.org/stable/python3-wheel) |
| `readsb-full` | `rtlsdr` | Contains the latest `dev` branch of [Mictronics/readsb-protobuf](https://github.com/Mictronics/readsb-protobuf) and all prerequisites for full functionality: ([bladeRF](https://github.com/Nuand/bladeRF), [bladeRF FPGA images](https://www.nuand.com/fpga_images/), [libiio (for PlutoSDR)](https://github.com/analogdevicesinc/libiio), [libad9361-iio (for PlutoSDR)](https://github.com/analogdevicesinc/libad9361-iio)) |
| `readsb-netonly` | `base` | Contains the latest `dev` branch of [Mictronics/readsb-protobuf](https://github.com/Mictronics/readsb-protobuf) intended to operate in network only mode. |
| `wreadsb-netonly` | `base` | Contains the latest `dev` branch of [wiedehopf's fork of readsb](https://github.com/wiedehopf/readsb) intended to operate in network only mode. |
| `rtlsdr` | `base` | Contains the latest tagged release of [rtl-sdr](https://osmocom.org/projects/rtl-sdr/), and prerequisites (eg: [libusb](https://packages.debian.org/stable/libusb-1.0-0)) |
| `soapyrtlsdr` | `rtlsdr` | Contains the latest tagged release of [SoapySDR](https://github.com/pothosware/SoapySDR) and [SoapyRTLSDR](https://github.com/pothosware/SoapyRTLSDR), and prerequisites ([python3](https://packages.debian.org/stable/python3), [python3-pip](https://packages.debian.org/stable/python3-pip), [python3-setuptools](https://packages.debian.org/stable/python3-setuptools), [python3-wheel](https://packages.debian.org/stable/python3-wheel)) |
| `dump978-full` | `soapyrtlsdr` | Contains the latest tagged release of [flightaware/dump978](https://github.com/flightaware/dump978), and prerequisites (various boost libraries) |
| `qemu` | `base` | Contains `qemu-user-static` binaries |

## Using

Simply add `FROM ghcr.io/sdr-enthusiasts/docker-baseimage:<tag>` at the top of your Dockerfile, replacing `<tag>` with one of the tags above.

The base image provides an `[ENTRYPOINT]` for starting the container so unless you have a specific reason to change this you do not have to provide an `[ENTRYPOINT]` in your `Dockerfile`.

Example:

```Dockerfile
FROM ghcr.io/sdr-enthusiasts/docker-baseimage:rtlsdr
RUN ...
```

## Tag-specific Notes

### `readsb-full`

* The readsb webapp and configuration files have been included in the image (see `/usr/share/readsb/html` and `/etc/lighttpd/conf-available`), however lighttpd has not been installed or configured. You will need to do this if you want this functionality in your image.
* The collectd configuration files have been included in the image (see `/etc/collectd/collectd.conf.d` and `/usr/share/readsb/graphs`), however collectd/rrdtool have not been installed or configured. You will need to do this if you want this functionality in your image.
* The installed version of readsb's protobuf protocol file is located at: `/opt/readsb-protobuf`, should you need this in your image.
* bladeRF FPGA firmware images are located at: `/usr/share/Nuand/bladeRF`

## Projects and Tag Tree

| Tag               | Sub-tags Using                 | Up-Stream Projects Using |
| ----------------- | ------------------------------ | ------------------------ |
| `base`            | `ALL`                          | [mikenye/adsbexchange](https://github.com/mikenye/docker-adsbexchange) |
| `acars-decoder`   | -                              | [fredclausen/docker-acarsdec](https://github.com/fredclausen/docker-acarsdec), [fredclausen/docker-dumpvdl2](https://github.com/fredclausen/docker-dumpvdl2) |
| `python`          | -                              | [fredclausen/docker-acarshub](https://github.com/fredclausen/docker-acarshub), [kx1t/docker-planefence](http://github.com/kx1t/docker-planefence), [kx1t/docker-radarvirtuel](http://github.com/kx1t/docker-radarvirtuel), [kx1t/docker-reversewebproxy](http://github.com/kx1t/docker-reversewebproxy) |
| `rtlsdr`          | `acars-decoder`, `readsb-full`, `soapyrtlsdr` | - |
| `readsb-full`     | -                              | [mikenye/readsb-protobuf](https://github.com/mikenye/docker-readsb-protobuf) |
| `readsb-netonly`  | -                              | - |
| `soapyrtlsdr`     | `dump978-full`                 | - |
| `dump978-full`    | -                              | [mikenye/piaware](https://github.com/mikenye/docker-piaware) |
| `wreadsb-netonly` | -                              | [mikenye/tar1090](https://github.com/mikenye/docker-tar1090) |
| `qemu`            | -                              | [mikenye/flightradar24](https://github.com/mikenye/docker-flightradar24) |
