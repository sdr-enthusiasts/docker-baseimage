# Trixie migration

## What this is

Currently, the SDR Enthusiasts Docker images are based on Debian Bookworm. Debian Trixie is the next version of Debian, and it was released in the summer of 2025. We are migrating our containers to Trixie to ensure continued support and access to the latest features and security updates.

> [!WARNING]
> ***IF YOU ARE RUNNING ADSB.IM THIS DOES NOT APPLY TO YOU. TESTING OF THESE IMAGES WILL BE DONE WHEN THE MAINTAINERS OF ADSB.IM ARE READY. RUNNING ANY OF THESE COMMANDS WILL LIKELY BREAK YOUR SETUP.***

## Testing procedure

For anyone who wants to help test the trixie migration, you can use the `trixie-latest` tag on each of the SDR-E images.

> [!IMPORTANT]
> "Safe" images does not mean they're 100% without bugs. Safe images are those that have been tested and confirmed to work with your CPU's architecture by a user or developer (generally), but every person's setup is different and you may run in to a problem based on your specific setup.

It is also going to "pin" the images to a fixed tag, so that you can easily roll back to the previous version if needed. If you want to move to the latest images, rerun the script and it will fetch the latest images and update as appropriate.

## FEEDBACK

If you are running an image that is marked as "ready for testing" but the CPU architecture is not marked as tested, please test it and report back so we can mark it as tested.

## Notes about the matrix below

Each image we intend to move over to trixie is listed below, along with its status.

You can see if the build is working. That means we've successfully built the image on GitHub CI, but that does not mean it is ready for testing.

The ready for testing column indicates that the image has been tested on at least one architecture (generally, but not always. Some images aren't applicable to my setup) and is ready for wider testing. You can see which architectures have been tested and which need feedback.

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
| [`acarshub`](https://github.com/sdr-enthusiasts/docker-acarshub) | ✅ | ✅ | ✅ | 💬 | ❌ |
| [`beast-splitter`](https://github.com/sdr-enthusiasts/docker-beast-splitter) | ✅ | ✅ | 💬 | 💬 | 💬 |
| [`flightradar24`](https://github.com/sdr-enthusiasts/docker-flightradar24) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`adsbhub`](https://github.com/sdr-enthusiasts/docker-adsbhub) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`opensky`](https://github.com/sdr-enthusiasts/docker-opensky-network) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`planefinder`](https://github.com/sdr-enthusiasts/docker-planefinder) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`acars_router`](https://github.com/sdr-enthusiasts/acars_router) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`airspy`](https://github.com/sdr-enthusiasts/airspy_adsb) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`reversewebproxy`](https://github.com/sdr-enthusiasts/docker-reversewebproxy) | ✅ | ✅ | 💬 | 💬 | 💬 |
| [`radar1090`](https://github.com/sdr-enthusiasts/docker-radar1090) | ✅ | ✅ | 💬 | 💬 | 💬 |
| `flightairmap` | ❌ | ❌ | ❌ | ❌ | ❌ |
| [`shipfeeder`](https://github.com/sdr-enthusiasts/docker-shipfeeder) | ✅ | ✅ | 💬 | 💬 | 💬 |
| [`aprs-tracker`](https://github.com/sdr-enthusiasts/docker-aprs-tracker) | ✅ | ✅ | 💬 | 💬 | 💬 |
| [`vessel-alert`](https://github.com/sdr-enthusiasts/docker-vesselalert) | ✅ | ✅ | 💬 | 💬 | 💬 |
| [`api2sbs`](https://github.com/sdr-enthusiasts/docker-api2sbs) | ✅ | ✅ | 💬 | 💬 | 💬 |
| [`docker-telegraf-adsb`](https://github.com/sdr-enthusiasts/docker-telegraf-adsb) | ✅ | ✅ | 💬 | 💬 | 💬 |

#### Base Image: `mlat-client`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| [`sdr-map`](https://github.com/sdr-enthusiasts/docker-sdrmap) | ✅ | ✅ | ✅ | 💬 | 💬 |

#### Base Image: `planefence_base`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| [`planefence`](https://github.com/sdr-enthusiasts/docker-planefence) | ✅ | ✅ | ✅ | ✅ | 💬 |

#### Base Image: `soapy-full`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| [`rtlsdr-airband`](https://github.com/sdr-enthusiasts/docker-rtlsdrairband) | ✅ | ✅ | 💬 | 💬 | ❌ |

#### Base Image: `wreadsb`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| [`airnav`](https://github.com/sdr-enthusiasts/docker-airnavradar) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`radarvirtuel`](https://github.com/sdr-enthusiasts/docker-radarvirtuel) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`tar1090`](https://github.com/sdr-enthusiasts/docker-tar1090) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`ultrafeeder`](https://github.com/sdr-enthusiasts/docker-adsb-ultrafeeder) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`sdrplay-1090`](https://github.com/sdr-enthusiasts/docker-sdrplay-beast1090) | ✅ | ✅ | 💬 | 💬 | ❌ |

#### Base Image: `acars-decoder-soapy`

| Image Name | Build Works | Ready for Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| [`acarsdec`](https://github.com/sdr-enthusiasts/docker-acarsdec) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`dumpvdl2`](https://github.com/sdr-enthusiasts/docker-dumpvdl2) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`vdlm2dec`](https://github.com/sdr-enthusiasts/docker-vdlm2dec) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`dumphfdl`](https://github.com/sdr-enthusiasts/docker-dumphfdl) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`hfdlobserver`](https://github.com/sdr-enthusiasts/docker-hfdlobserver) | ✅ | ✅ | ✅ | 💬 | 💬 |

#### Base Image: `dump978-full`

| Image Name | Build Works | Ready for Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| [`dump978`](https://github.com/sdr-enthusiasts/docker-dump978) | ✅ | ✅ | ✅ | 💬 | 💬 |
| [`piaware`](https://github.com/sdr-enthusiasts/docker-piaware) | ✅ | ✅ | ✅ | 💬 | 💬 |

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

- `acarshub` image: arm32 is no longer supported
- `rtlsdrairband` image: arm32 is no longer supported
- `sdrplay-beast1090` image: arm32 is no longer supported

## Open Testing Questions

- `rtlsdr-airband` image: Does the removal of mime-types library cause any problems?
