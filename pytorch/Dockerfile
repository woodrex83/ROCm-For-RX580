FROM rocm-for-gfx803-dev:latest

ENV UBUNTU_VERSION=22.04
ENV MAGMA_VERSION=2.7.1
ENV ROCM_BUILD_NUMBER=74
ENV ROCM_MAJOR_VERSION=5
ENV ROCM_MINOR_VERSION=5
ENV ROCM_PATCH_VERSION=1
ENV ROCM_VERSION=5.5.1
ENV ROCM_PATH=/opt/rocm-5.5.1
ENV PYTORCH_VERSION=2.0.1
ENV PYTORCH_VISION_VERSION=0.15.2
ENV PYTORCH_AUDIO_VERSION=2.0.2
ENV OPENCV_VERSION=4.8.0.76
ENV NUM_CPU_CORES=$(nproc)
ENV USE_FFMPEG=1

LABEL org.opencontainers.image.authors="Patrick Mok <woodrex83@gmail.com>"

# Pytorch deps
WORKDIR /git
RUN --mount=type=cache,target=/var/cache/apt,rw --mount=type=cache,target=/var/lib/apt,rw \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3-dev \
    pkg-config \
    ninja-build \
    libavfilter-dev \
    libavdevice-dev \
    libpng-dev \
    libjpeg-turbo8-dev \
    ffmpeg \
    libavcodec-dev \
    libswscale-dev \
    libavutil-dev \
    libswresample-dev \
    libavformat-dev \
    libdnnl-dev \
    libstdc++-12-dev \
    libopenmpi3 \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN pip install astunparse numpy ninja pyyaml setuptools cmake cffi typing_extensions future six requests dataclasses

# Build torch
WORKDIR /git
RUN git clone --recursive https://github.com/pytorch/pytorch.git -b v2.1.2
RUN mkdir -p /build
ENV HIPCC_COMPILE_FLAGS_APPEND="-parallel-jobs=${NUM_CPU_CORES}"
ENV HIPCC_LINK_FLAGS_APPEND="-parallel-jobs=${NUM_CPU_CORES}"

# Build torch wheel
WORKDIR /git/pytorch
RUN rm version.txt
RUN echo "2.1.2" > version.txt
RUN python tools/amd_build/build_amd.py
RUN python setup.py bdist_wheel
RUN pip install --no-cache-dir /git/pytorch/dist/torch-*.whl

# Build torchvision
WORKDIR /git
RUN git clone --recursive https://github.com/pytorch/vision.git -b v0.16.2

# Build torchvision wheel
WORKDIR /git/vision

# Fix bin/hipcc not found, because ROCM_HOME is not settled
# https://github.com/pytorch/vision/issues/6707#issuecomment-1269640873
ENV ROCM_HOME=/opt/rocm-${ROCM_VERSION}
ENV BUILD_VERSION=0.16.2
RUN TORCHVISION_USE_NVJPEG=0 \
    TORCHVISION_USE_VIDEO_CODEC=0 \
    TORCHVISION_USE_FFMPEG=1 \
    PYTORCH_VERSION=2.1.2 \
    FORCE_CUDA=1 \
    python setup.py bdist_wheel
RUN pip install --no-cache-dir /git/vision/dist/torchvision-*.whl

RUN rm -f /git

WORKDIR /app