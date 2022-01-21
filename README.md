# SDR Docker Base Image

## Purpose

Provide a basic image, with all normal packages common to all installs of @mikenye ADSB, @fredclausen, or @kx1t SDR docker images, to reduce download time for users.

## Installed Packages

Based on Debian Bullseye

* [Mike Nye S6 framework](https://github.com/mikenye/deploy-s6-overlay)
* [Mike Nye Healthcheck](https://github.com/mikenye/docker-healthchecks-framework)
* ca-certificates
* curl
* file
* gawk
* pv
