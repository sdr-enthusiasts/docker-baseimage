# Trixie migration

## What this is

Currently, the SDR Enthusiasts Docker images are based on Debian Bookworm. Debian Trixie is the next version of Debian, and it is expected to be released in mid 2025. This migration will update the base images to use Debian Trixie, which will allow us to take advantage of the latest features and improvements in Debian.

In order to ensure a smooth transition, each image will need to be tested on each architecture we support. This document will track the progress of the migration and provide instructions for testing the images.

There is going to be no wide release until Trixie is officially released, all images have been tested, and all images have been confirmed to work on all architectures. I fully anticipate that we will have a working set of images before Trixie is released, but the intent is to give a few month's time past Trixie's release to ensure that everything is working as expected.

The wider the participation in testing, the faster we can get to a stable release. If you want to help test the images, please follow the instructions below.

> [!WARNING]
> ***IF YOU ARE RUNNING ADSB.IM THIS DOES NOT APPLY TO YOU. TESTING OF THESE IMAGES WILL BE DONE WHEN THE MAINTAINERS OF ADSB.IM ARE READY. RUNNING ANY OF THESE COMMANDS WILL LIKELY BREAK YOUR SETUP.***

## Testing procedure

For anyone who wants to help test the trixie migration, please follow these steps:

```shell
cd /path/to/your/docker-compose-directory
curl -s https://raw.githubusercontent.com/sdr-enthusiasts/docker-baseimage/main/update_docker_compose.py -o update_docker_compose.py
cp docker-compose.yml docker-compose.yml.bak
python3 update_docker_compose.py
```

> [!WARNING]
> **BEFORE RUNNING THIS SCRIPT ENSURE YOU HAVE A BACKUP OF YOUR `docker-compose.yml` FILE.**

You can see all available options for the script by running:

```shell
python3 update_docker_compose.py --help
```

By default, it will replace any images currently in your `docker-compose.yml` file with any images we've updated to `debian trixie`. You can specify to only use "safe" images, which are images that have been tested and confirmed to work with your CPU's architecture.

> [!IMPORTANT]
> "Safe" images does not mean they're 100% without bugs. Safe images are those that have been tested and confirmed to work with your CPU's architecture by a user or developer (generally), but every person's setup is different and you may run in to a problem based on your specific setup.

It is also going to "pin" the images to a fixed tag, so that you can easily roll back to the previous version if needed. If you want to move to the latest images, rerun the script and it will fetch the latest images and update as appropriate.

## FEEDBACK

If you are running an image that is marked as "ready for testing" but the CPU architecture is not marked as tested, please test it and report back so we can mark it as tested.

## Notes about the matrix below

Each image we intend to move over to trixie is listed below, along with its status.

You can see if the build is working. That means we've successfully built the image on GitHub CI, but that does not mean it is ready for testing.

The ready for testing column indicates that the image has been tested on at least one architecture (generally, but not always. Some images aren't applicable to my setup) and is ready for wider testing. You can see which architectures have been tested. Just because there is a ❌ in the column does not mean it will not work, it just means we have not tested it on that architecture yet.

## Matrix

### Key

| Key | Description |
| -- | -- |
| ✅ | Completed |
| 🟡 | Work In Progress |
| 💬 | Ready for testing. Feedback requested |
| ❌ | Will Not Complete |

### Base Images

| Image Name | Build Works |
| -- | - |
| `base` | ✅ |
| `mlat-client` | ✅ |
| `planefence_base` | ✅ |
| `soapy-full` | ✅ |
| `wreadsb` | ✅ |
| `acars-decoder-soapy` | ✅ |
| `dump978-full` | ✅ |

### Base Image Child Images

#### Base Image: `base`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `acarshub` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `beast-splitter` | ✅ | ✅ | 💬 | 💬 | 💬 |
| `flightradar24` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `adsbhub` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `opensky` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `planefinder` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `acars_router` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `airspy` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `reversewebproxy` | ✅ | ✅ | 💬 | 💬 | 💬 |
| `radar1090` | ✅ | ✅ | 🟡 | 🟡 | 🟡 |
| `flightairmap` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `shipfeeder` | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |
| `aprs-tracker` | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |
| `vessel-alert` | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |

#### Base Image: `mlat-client`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `sdr-map` | ✅ | ✅ | ✅ | 💬 | 💬 |

#### Base Image: `planefence_base`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `planefence` | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |

#### Base Image: `soapy-full`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `rtlsdrairband` | ✅ | ✅ | 💬 | 💬 | 💬 |

#### Base Image: `wreadsb`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `airnav` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `radarvirtuel` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `tar1090` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `ultrafeeder` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `sdrplay-1090` | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 |

#### Base Image: `acars-decoder-soapy`

| Image Name | Build Works | Ready for Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `acarsdec` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `dumpvdl2` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `vdlm2dec` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `dumphfdl` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `hfdlobserver` | ✅ | ✅ | ✅ | 💬 | 💬 |

#### Base Image: `dump978-full`

| Image Name | Build Works | Ready for Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `dump978` | ✅ | ✅ | ✅ | 💬 | 💬 |
| `piaware` | ✅ | ✅ | ✅ | 💬 | 💬 |

## Tasks

### Tasks for pre trixie deployment

- [ ] Archive the current docker images
- [ ] Move the trixie docker files to the base dir

### Tasks for post trixie deployment

- [ ] Remove `deploy_trixie.yml`
  - [ ] `acarshub`
  - [ ] `acarsdec`
  - [ ] `dumpvdl2`
  - [ ] `dumphfdl`
  - [ ] `hfdlobserver`
  - [ ] `vdlm2dec`
- [ ] Remove trixie check for `libglib2.0-0` and `libconfig++`
  - [ ] docker-dumpvdl2
  - [ ] docker-dumphfdl
  - [ ] docker-hfdlobserver
- [ ] Move back to main branch for the dumphfdl clone
  - [ ] docker-dumphfdl
  - [ ] docker-hfdlobserver
- [ ] Fix trigger for tar1090->ultra to just use regular deploy

## Current blockers

**NONE!**

## Deprecations

- `rtlsdrairband` image: arm32 is no longer supported

## Open Testing Questions

- `rtlsdr-airband` image: Does the removal of mime-types library cause any problems?
