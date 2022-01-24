# SDR Docker Base Image

## Purpose

Provide a basic image, with all normal packages common to all installs of [mikenye](https://github.com/mikenye/), [fredclausen](https://github.com/fredclausen), or [kx1t](https://github.com/kx1t/) SDR docker images, to reduce download time and disk space usage for users.

## Tags

| Tag | Extends | Included Packages |
| --- | ------- | ------------------|
| `base` | - | [s6-overlay](https://github.com/just-containers/s6-overlay) (via [mikenye/deploy-s6-overlay](https://github.com/mikenye/deploy-s6-overlay)), [mikenye/docker-healthchecks-framework](https://github.com/mikenye/docker-healthchecks-framework), [ca-certificates](https://packages.debian.org/stable/ca-certificates), [curl](https://packages.debian.org/stable/curl), [gawk](https://packages.debian.org/stable/gawk) |
| `rtlsdr` | `base` | [libusb](https://packages.debian.org/stable/libusb-1.0-0), [rtl-sdr](https://osmocom.org/projects/rtl-sdr/)

## Using

Simply add `FROM ghcr.io/fredclausen/docker-baseimage:<tag>` at the top of your Dockerfile, replacing `<tag>` with one of the tags above.

Example:

```Dockerfile
FROM ghcr.io/fredclausen/docker-baseimage:rtlsdr
RUN ...
```
