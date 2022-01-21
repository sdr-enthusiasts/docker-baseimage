FROM debian:bullseye-20211220-slim

ENV BRANCH_RTLSDR="ed0317e6a58c098874ac58b769cf2e609c18d9a5" \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,SC2086
RUN set -x && \
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    # logging
    KEPT_PACKAGES+=(gawk) && \
    KEPT_PACKAGES+=(pv) && \
    # required for S6 overlay
    # curl kept for healthcheck
    TEMP_PACKAGES+=(gnupg2) && \
    KEPT_PACKAGES+=(file) && \
    KEPT_PACKAGES+=(curl) && \
    KEPT_PACKAGES+=(ca-certificates) && \
    # install packages
    ## Builder fixes...
    mkdir -p /usr/sbin/ && \
    ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split && \
    ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb && \
    ln -s /bin/tar /usr/sbin/tar && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        "${KEPT_PACKAGES[@]}" \
        "${TEMP_PACKAGES[@]}"\
        && \
    # install S6 Overlay
    curl -s https://raw.githubusercontent.com/mikenye/deploy-s6-overlay/master/deploy-s6-overlay.sh | sh && \
    # deploy healthchecks framework
    git clone \
      --depth=1 \
      https://github.com/mikenye/docker-healthchecks-framework.git \
      /opt/healthchecks-framework \
      && \
    rm -rf \
      /opt/healthchecks-framework/.git* \
      /opt/healthchecks-framework/*.md \
      /opt/healthchecks-framework/tests \
      && \
    # Clean up
    apt-get remove -y "${TEMP_PACKAGES[@]}" && \
    apt-get autoremove -y && \
    rm -rf /src/* /tmp/* /var/lib/apt/lists/*

ENTRYPOINT [ "/init" ]
