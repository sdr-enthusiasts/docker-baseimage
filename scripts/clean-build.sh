#!/bin/bash
rm -rf \
    /tmp/* \
    /var/tmp/* \
    /var/cache/* \
    /var/log/* \
    /var/lib/apt/lists/* \
    /var/lib/dpkg/status-old

# remove pycache, nothing found doesn't mean failure thus always return true
find /usr | grep -E "/__pycache__$" | xargs rm -rf || true
