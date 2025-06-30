# Trixie migration

## Tasks for pre trixie deployment

- [ ] Archive the current docker images
- [ ] Move the trixie docker files to the base dir

## Tasks for post trixie deployment

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

## Key

| Key | Description |
| -- | -- |
| ✅ | Completed |
| ❌ | Not completed |

## Base Images

| Image Name | Build Works |
| -- | - |
| `base` | ✅ |
| `mlat-client` | ✅ |
| `planefence_base` | ✅ |
| `soapy-full` | ✅ |
| `wreadsb` | ✅ |
| `acars-decoder-soapy` | ✅ |
| `dump978-full` | ✅ |

## Base Image Child Images

### Base Image: `base`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `acarshub` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `beast-splitter` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `flightradar24` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `adsbhub` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `opensky` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `planefinder` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `acars_router` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `airspy` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `reversewebproxy` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `radar1090` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `flightairmap` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `shipfeeder` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `aprs-tracker` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `vessel-alert` | ❌ | ❌ | ❌ | ❌ | ❌ |

### Base Image: `mlat-client`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `sdr-map` | ❌ | ❌ | ❌ | ❌ | ❌ |

### Base Image: `planefence_base`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `planefence` | ❌ | ❌ | ❌ | ❌ | ❌ |

### Base Image: `soapy-full`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `rtlsdrairband` | ❌ | ❌ | ❌ | ❌ | ❌ |

### Base Image: `wreadsb`

| Image Name | Build Works | Ready For Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `airnav` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `radarvirtuel` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `tar1090` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `ultrafeeder` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `sdrplay-1090` | ❌ | ❌ | ❌ | ❌ | ❌ |

### Base Image: `acars-decoder-soapy`

| Image Name | Build Works | Ready for Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `acarsdec` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `dumpvdl2` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `vdlm2dec` | ✅ | ❌ | ✅ | ❌ | ❌ |
| `dumphfdl` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `hfdlobserver` | ✅ | ❌ | ❌ | ❌ | ❌ |

### Base Image: `dump978-full`

| Image Name | Build Works | Ready for Testing | AMD64 | ARM64 | ARMv7 |
| -- | - | - | - | - | - |
| `dump978` | ❌ | ❌ | ❌ | ❌ | ❌ |
| `piaware` | ❌ | ❌ | ❌ | ❌ | ❌ |
