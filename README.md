# SDR Docker Base Image

## Purpose

Provide a basic image, with all normal packages common to all installs of [mikenye](https://github.com/mikenye/), [fredclausen](https://github.com/fredclausen), or [kx1t](https://github.com/kx1t/) SDR docker images, to reduce download time for users.

## Installed Packages

Based on Debian Bullseye

* [s6-overlay](https://github.com/just-containers/s6-overlay) (via [mikenye/deploy-s6-overlay](https://github.com/mikenye/deploy-s6-overlay))
* [Mike Nye's Healthcheck Framework](https://github.com/mikenye/docker-healthchecks-framework)
* ca-certificates
* curl
* gawk
* pv
