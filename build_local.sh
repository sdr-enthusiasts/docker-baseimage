#!/usr/bin/env bash

# grab the first argument. It should be "bookworm", "trixie", or "forky"

VARIANT="$1"
# grab the second argument. It should be "clean" if you want to remove all images before the build
CLEAN="$2"

BUILD_PATH="./"

# Each image is built FROM the previous local one, so the builder must use the
# local image store. A docker-container buildx builder neither loads results
# locally nor resolves FROM against local images (it pulls the published tags).
BUILDER="default"

# Prepended to every image tag. The forky Dockerfiles build FROM forky-* tags so
# they never collide with (or silently build on) the trixie images.
TAG_PREFIX=""

if [ -z "$VARIANT" ]; then
    echo "Usage: $0 <bookworm|trixie|forky> <clean>"
    echo "If you add clean to the command, it will remove all images before the build."
    exit 1
fi

# check if the argument is valid

if [ "$VARIANT" != "bookworm" ] && [ "$VARIANT" != "trixie" ] && [ "$VARIANT" != "forky" ]; then
    echo "Invalid variant: $VARIANT. Use 'bookworm', 'trixie', or 'forky'."
    exit 1
fi

# if the second argument is "clean"
if [ "$CLEAN" == "clean" ]; then
    echo -e "\033[0;31mWARNING: This will remove ALL Docker containers!\033[0m"
    read -rp "Are you sure you want to continue? (y/N): " confirm

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

# The repo root holds the trixie Dockerfiles; bookworm was moved to
# bookworm-legacy/ when trixie was promoted to the default (commit 8704a43).
# forky/ is an experimental copy of the trixie Dockerfiles on debian forky.
if [ "$VARIANT" == "bookworm" ]; then
    BUILD_PATH="./bookworm-legacy"
elif [ "$VARIANT" == "trixie" ]; then
    BUILD_PATH="./"
elif [ "$VARIANT" == "forky" ]; then
    BUILD_PATH="./forky"
    TAG_PREFIX="forky-"
fi

# build each image in order; stop on the first failure since later images
# are built FROM earlier ones
build_image() {
    local step="$1"
    local tag="$2"

    echo "Step $step: Building ${TAG_PREFIX}${tag} image for variant: $VARIANT"

    if ! docker build --builder "$BUILDER" -t ghcr.io/sdr-enthusiasts/docker-baseimage:"${TAG_PREFIX}${tag}" -f "$BUILD_PATH"/Dockerfile."$tag" .; then
        echo -e "\033[0;31mStep $step: Failed to build ${TAG_PREFIX}${tag} image for variant: $VARIANT. Exiting.\033[0m"
        exit 1
    fi
}

build_image 1 base
build_image 2 mlatclient
build_image 3 planefence_base
build_image 4 soapy-full
build_image 5 wreadsb
build_image 6 acars-decoder-soapy
build_image 7 dump978-full
