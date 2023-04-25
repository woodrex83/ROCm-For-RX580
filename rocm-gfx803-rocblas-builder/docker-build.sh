#!/bin/bash

ARG_UBUNTU_VERSION="20.04"
ARG_ROCM_MAJOR_VERSION="5"
ARG_ROCM_MINOR_VERSION="4"
ARG_ROCM_PATCH_VERSION="3"
ARG_ROCM_BUILD_NUMBER="121"
ARG_ROCM_LIBPATCH_VERSION=$(printf "%d%02d%02d" ${ARG_ROCM_MAJOR_VERSION} ${ARG_ROCM_MINOR_VERSION} ${ARG_ROCM_PATCH_VERSION})
echo "ARG_ROCM_LIBPATCH_VERSION: $ARG_ROCM_LIBPATCH_VERSION"

ROCM_VERSION="${ARG_ROCM_MAJOR_VERSION}.${ARG_ROCM_MINOR_VERSION}.${ARG_ROCM_PATCH_VERSION}"

docker_image_name="ulyssesrr/rocm-gfx803-rocblas-builder"
docker_image_tag="ubuntu${ARG_UBUNTU_VERSION}_rocm${ROCM_VERSION}"
docker build \
  --build-arg "UBUNTU_VERSION=$ARG_UBUNTU_VERSION" \
  --build-arg "ROCM_MAJOR_VERSION=$ARG_ROCM_MAJOR_VERSION" \
  --build-arg "ROCM_MINOR_VERSION=$ARG_ROCM_MINOR_VERSION" \
  --build-arg "ROCM_PATCH_VERSION=$ARG_ROCM_PATCH_VERSION" \
  --build-arg "ROCM_BUILD_NUMBER=$ARG_ROCM_BUILD_NUMBER" \
  --build-arg "ROCM_LIBPATCH_VERSION=$ARG_ROCM_LIBPATCH_VERSION" \
  --build-arg "ROCM_VERSION=$ROCM_VERSION" \
  -t "$docker_image_name:$docker_image_tag" .