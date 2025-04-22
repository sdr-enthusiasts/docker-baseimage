# SDR Docker Base Image

## Purpose

Provide a basic image, with all normal packages common to all installs of [mikenye][mikenye], [fredclausen][fredclausen], or [kx1t][kx1t] SDR docker images, to reduce download time and disk space usage for users.

## Adding containers

1) Create your new docker file
2) [Update github actions](Add-New-Container-Template.MD)
3) Update the [Tags](#tags) section
4) Update the [Projects and Tag Tree](#projects-and-tag-tree) section

## Tags

| Tag | Extends | Included Packages |
| --- | ------- | ------------------|
| `base` | - | [s6-overlay][s6-overlay] (via [mikenye/deploy-s6-overlay][mikenye/deploy-s6-overlay]), [mikenye/docker-healthchecks-framework][mikenye/docker-healthchecks-framework], [bc][bc], [ca-certificates][ca-certificates], [curl][curl], [gawk][gawk], [ncat][ncat], [net-tools][net-tools], [procps][procps], [socat][socat], [python3][python3], [python3-pkg-resources][python3-pkg-resources] |
| `acars-decoder` | `rtlsdr` | [libacars][libacars] and all prerequisites for full functionality: ([zlib1g][zlib1g], [libxml2][libxml2], [libsqlite3][libsqlite3]) |
| `readsb-full` | `rtlsdr` | Contains the latest `dev` branch of [Mictronics/readsb-protobuf] and all prerequisites for full functionality: ([bladeRF][bladeRF], [bladeRF FPGA images][bladeRF FPGA images], [libiio (for PlutoSDR)][libiio], [libad9361-iio (for PlutoSDR)][libad9361-iio]) |
| `wreadsb` | `base` | Contains the latest `dev` branch of [wiedehopf's fork of readsb][wiedehopf/readsb] with [rtl-sdr][rtl-sdr] & [libusb][libusb]. |
| `rtlsdr` | `base` | Contains the latest master branch of [rtl-sdr][rtl-sdr] and latest tagged release of [SoapyRTLSDR][SoapyRTLSDR], and prerequisites (eg: [libusb][libusb]) |
| `dump978-full` | `wreadsb` | Contains the latest tagged release of [flightaware/dump978][flightaware/dump978], and prerequisites (various boost libraries) |

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
| `base`            | `ALL`                          | [sdr-enthusiasts/acars_router][acars_router],[sdr-enthusiasts/airspy-adsb][airspy], [sdr-enthusiasts/docker-adsbhub][docker-adsbhub], [sdr-enthusiasts/docker-opensky-network][docker-opensky-network], [sdr-enthusiasts/docker-rtlsdrairband][docker-rtlsdrairband], [sdr-enthusiasts/docker-flightradar24][docker-flightradar24], [sdr-enthusiasts/docker-planefinder][docker-planefinder], [sdr-enthusiasts/docker-acarshub][docker-acarshub], [sdr-enthusiasts/docker-adsbexchange][docker-adsbexchange], [kx1t/docker-planefence][docker-planefence], [sdr-enthusiasts/docker-reversewebproxy][docker-reversewebproxy], [kx1t/docker-raspberry-noaa-v2][docker-raspberry-noaa-v2] |
| `acars-decoder`   | -                              | [sdr-enthusiasts/docker-acarsdec][docker-acarsdec], [sdr-enthusiasts/docker-dumpvdl2][docker-dumpvdl2], [sdr-enthusiasts/docker-vdlm2dec][docker-vdlm2dec] |
| `rtlsdr`          | `acars-decoder`, `readsb-full`, `wreadsb` | [sdr-enthusiasts/acars-oxide][acars-oxide] |
| `readsb-full`     | -                              | [sdr-enthusiasts/docker-readsb-protobuf][docker-readsb-protobuf] |
| `dump978-full`    | -                              | [sdr-enthusiasts/docker-piaware][docker-piaware], [sdr-enthusiasts/docker-dump978][docker-dump978]  |
| `wreadsb`         | `dump978-full`                 | [sdr-enthusiasts/docker-tar1090][docker-tar1090], [sdr-enthusiasts/docker-radarvirtuel][docker-radarvirtuel], [sdr-enthusiasts/docker-airnavradar][docker-airnavradar] |

<!-- links below here -->
[acars_router]: https://github.com/sdr-enthusiasts/acars-router
[acars-oxide]: https://github.com/sdr-enthusiasts/acars-oxide
[airspy]: https://github.com/sdr-enthusiasts/airspy_adsb
[bc]: https://packages.debian.org/stable/bc
[bladeRF FPGA images]: https://www.nuand.com/fpga_images/
[bladeRF]: https://github.com/Nuand/bladeRF
[ca-certificates]: https://packages.debian.org/stable/ca-certificates
[curl]: https://packages.debian.org/stable/curl
[docker-acarsdec]: https://github.com/sdr-enthusiasts/docker-acarsdec
[docker-acarshub]: https://github.com/sdr-enthusiasts/docker-acarshub
[docker-adsbexchange]: https://github.com/sdr-enthusiasts/docker-adsbexchange
[docker-adsbhub]: https://github.com/sdr-enthusiasts/docker-adsbhub
[docker-dump978]: https://github.com/sdr-enthusiasts/docker-dump978
[docker-dumpvdl2]: https://github.com/sdr-enthusiasts/docker-dumpvdl2
[docker-flightradar24]: https://github.com/sdr-enthusiasts/docker-flightradar24
[docker-opensky-network]: https://github.com/sdr-enthusiasts/docker-opensky-network
[docker-piaware]: https://github.com/sdr-enthusiasts/docker-piaware
[docker-planefence]: http://github.com/kx1t/docker-planefence
[docker-planefinder]: https://github.com/sdr-enthusiasts/docker-planefinder
[docker-airnavradar]: https://github.com/sdr-enthusiasts/docker-airnavradar
[docker-radarvirtuel]: https://github.com/sdr-enthusiasts/docker-radarvirtuel
[docker-raspberry-noaa-v2]: https://github.com/kx1t/docker-raspberry-noaa-v2
[docker-readsb-protobuf]: https://github.com/sdr-enthusiasts/docker-readsb-protobuf
[docker-reversewebproxy]: https://github.com/sdr-enthusiasts/docker-reversewebproxy
[docker-rtlsdrairband]: https://github.com/sdr-enthusiasts/docker-rtlsdrairband
[docker-tar1090]: https://github.com/sdr-enthusiasts/docker-tar1090
[docker-vdlm2dec]: https://github.com/sdr-enthusiasts/docker-vdlm2dec
[flightaware/dump978]: https://github.com/flightaware/dump978
[fredclausen]: https://github.com/fredclausen
[gawk]: https://packages.debian.org/stable/gawk
[kx1t]: https://github.com/kx1t/
[libacars]: https://github.com/szpajder/libacars
[libad9361-iio]: https://github.com/analogdevicesinc/libad9361-iio
[libiio]: https://github.com/analogdevicesinc/libiio
[libsqlite3]: https://packages.debian.org/stable/libsqlite3
[libusb]: https://packages.debian.org/stable/libusb-1.0-0
[libxml2]: https://packages.debian.org/stable/libxml2
[Mictronics/readsb-protobuf]: https://github.com/Mictronics/readsb-protobuf
[mikenye]: https://github.com/mikenye/
[mikenye/deploy-s6-overlay]: https://github.com/mikenye/deploy-s6-overlay
[mikenye/docker-healthchecks-framework]: https://github.com/mikenye/docker-healthchecks-framework
[ncat]: https://packages.debian.org/stable/ncat
[net-tools]: https://packages.debian.org/stable/net-tools
[procps]: https://packages.debian.org/stable/procps
[python3-pip]: https://packages.debian.org/stable/python3-pip
[python3-setuptools]: https://packages.debian.org/stable/python3-setuptools
[python3-wheel]: https://packages.debian.org/stable/python3-wheel
[python3]: https://packages.debian.org/stable/python3
[qemu-user-static]: https://packages.debian.org/stable/qemu-user-static
[rtl-sdr]: https://osmocom.org/projects/rtl-sdr/
[s6-overlay]: https://github.com/just-containers/s6-overlay
[SoapyRTLSDR]: https://github.com/pothosware/SoapyRTLSDR
[SoapySDR]: https://github.com/pothosware/SoapySDR
[socat]: https://packages.debian.org/stable/socat
[wiedehopf/readsb]: https://github.com/wiedehopf/readsb
[zlib1g]: https://packages.debian.org/stable/zlib1g
