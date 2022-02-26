# List of ADSB/ACARS Containers

Below is a list of all containers created to receive, feed, display, or otherwise enjoy using your SDRs to see what airplanes are doing above your head, along with links to [Dockerhub](https://dockerhub.com) and [Github Code Repository](https://github.com) URLs. When present, `GHCR` is the preferred link to use for the image in your compose files as Dockerhub images may end up being discontinued at some point.

All links will be for the `:latest` tag for each container.

## ADSB SDR Interfaces

| Name | DockerHub URL | GHCR Url |
| [docker-readsb-protobuf](https://github.com/sdr-enthusiasts/docker-readsb-protobuf)| `mikenye/readsb-protobuf` | `ghcr.io/sdr-enthusiasts/docker-readsb-protobuf:latest` |  |
| [docker-dump978](https://github.com/sdr-enthusiasts/docker-dump978) | `mikenye/dump978` |`ghcr.io/sdr-enthusiasts/docker-dump978:latest` |

## ADSB Feeding

| Name | DockerHub URL | GHCR Url |
| [docker-adsbhub](https://github.com/mikenye/docker-adsbhub) | `mikenye/adsbhub` | `NONE` |
| [docker-adsbexchange](https://github.com/mikenye/docker-adsbexchange) | `mikenye/adsbexchange` | `NONE` |
| [docker-flightradar24](https://github.com/sdr-enthusiasts/docker-flightradar24) | `mikenye/flightradar24` | `ghcr.io/sdr-enthusiasts/docker-flightradar24:latest` |
| [docker-opensky-network](https://github.com/mikenye/docker-opensky-network) | `mikenye/opensky-network` | `NONE` |
| [docker-piaware] | `mikenye/piaware` | `https://github.com/sdr-enthusiasts/docker-piaware` |
| [docker-radarbox](https://github.com/sdr-enthusiasts/docker-radarbox) | `mikenye/radarbox` | `ghcr.io/sdr-enthusiasts/docker-radarbox:latest` |
| [docker-radarvirtuel](https://github.com/sdr-enthusiasts/docker-radarvirtuel) | `kx1t/radarvirtuel` | `ghcr.io/sdr-enthusiasts/docker-radarvirtuel:latest` |

## ACARS

| Name | DockerHub URL | GHCR Url |

[acars_router](https://github.com/sdr-enthusiasts/acars_router) | `NONE` | `ghcr.io/sdr-enthusiasts/acars_router:latest` |
[docker-acarsdec](https://github.com/sdr-enthusiasts/docker-acarsdec) | `NONE` | `ghcr.io/sdr-enthusiasts/docker-acarsdec:latest` |
[docker-acarshub](https://github.com/sdr-enthusiasts/docker-acarshub) | `NONE` | `ghcr.io/sdr-enthusiasts/docker-acarshub:latest` |
[docker-dumpvdl2](https://github.com/sdr-enthusiasts/docker-dumpvdl2) | `NONE` | `ghcr.io/sdr-enthusiasts/docker-dumpvdl2:latest` |
[docker-vdlm2dec](https://github.com/sdr-enthusiasts/docker-vdlm2dec) | `NONE` | `ghcr.io/sdr-enthusiasts/docker-vdlm2dec:latest` |

## Miscellaneous

| Name | DockerHub URL | GHCR Url |

| [docker-planefence](https://github.com/kx1t/docker-planefence) | `kx1t/planefence` | `NONE` |
| [docker-rtlsdrairband](https://github.com/sdr-enthusiasts/docker-rtlsdrairband) | `fredclausen/rtlsdrairband` | `ghcr.io/sdr-enthusiasts/docker-rtlsdrairband:latest` |
| [docker-tar1090](https://github.com/sdr-enthusiasts/docker-tar1090) | `mikenye/tar1090` | `ghcr.io/sdr-enthusiasts/docker-tar1090:latest` |
| [docker-webproxy](https://github.com/sdr-enthusiasts/docker-reversewebproxy) | `kx1t/webproxy:latest` | `NONE` |
