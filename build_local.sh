#!/usr/bin/env bash

# grab the first argument. It should be either "bookworm" or "trixie"

VARIANT="$1"
# grab the second argument. It should be "clean" if you want to remove all images before the build
CLEAN="$2"

BUILD_PATH="./"

if [ -z "$VARIANT" ]; then
    echo "Usage: $0 <bookworm|trixie> <clean>"
    echo "If you add clean to the command, it will remove all images before the build."
    exit 1
fi

# check if the argument is valid

if [ "$VARIANT" != "bookworm" ] && [ "$VARIANT" != "trixie" ]; then
    echo "Invalid variant: $VARIANT. Use 'bookworm' or 'trixie'."
    exit 1
fi

# if the second argument is "clean"
if [ "$CLEAN" == "clean" ]; then
    echo -e "\033[0;31mWARNING: This will remove ALL Docker containers!\033[0m"
    read -p "Are you sure you want to continue? (y/N): " confirm

    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Exiting without cleaning up old images. Please re-run with 'clean' if you want to remove old images or re-run without 'clean' to skip this step."
        exit 0
    fi

    # shellcheck disable=SC2046
    if [ $(docker image ls -q | wc -l) -eq 0 ]; then
        echo "No images to remove."
    else
        # shellcheck disable=SC2046
        if ! docker rmi -f $(docker images -aq); then
            echo "Failed to remove old images. Exiting."
            exit 1
        fi
   fi
else
     echo "Skipping cleanup of old images."
fi

if [ "$VARIANT" == "bookworm" ]; then
    BUILD_PATH="./"
elif [ "$VARIANT" == "trixie" ]; then
    BUILD_PATH="./trixie"
fi

# build the base

echo "Step 1: Building base image for variant: $VARIANT"

docker build -t ghcr.io/sdr-enthusiasts/docker-baseimage:base -f "$BUILD_PATH"/Dockerfile.base .

# now the images off of the base image

echo "Step 2: Building mlatclient image for variant: $VARIANT"

docker build -t ghcr.io/sdr-enthusiasts/docker-baseimage:mlatclient -f "$BUILD_PATH"/Dockerfile.mlatclient .

echo "Step 3: Building planefence image for variant: $VARIANT"

docker build -t ghcr.io/sdr-enthusiasts/docker-baseimage:planefence_base -f "$BUILD_PATH"/Dockerfile.planefence_base .

echo "Step 4: Building soapy-full image for variant: $VARIANT"
docker build -t ghcr.io/sdr-enthusiasts/docker-baseimage:soapy-full -f "$BUILD_PATH"/Dockerfile.soapy-full .

echo "Step 5: Building wreadsb image for variant: $VARIANT"
docker build -t ghcr.io/sdr-enthusiasts/docker-baseimage:wreadsb -f "$BUILD_PATH"/Dockerfile.wreadsb .

echo "Step 6: Building acars-decoder-soapy image for variant: $VARIANT"
docker build -t ghcr.io/sdr-enthusiasts/docker-baseimage:acars-decoder-soapy -f "$BUILD_PATH"/Dockerfile.acars-decoder-soapy .

echo "Step 7: Building dump978-full image for variant: $VARIANT"
docker build -t ghcr.io/sdr-enthusiasts/docker-baseimage:dump978-full -f "$BUILD_PATH"/Dockerfile.dump978-full .
