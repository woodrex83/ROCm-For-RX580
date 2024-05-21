FROM rocm-for-gfx803-dev:latest

ENV UBUNTU_VERSION=22.04
ENV MAGMA_VERSION=2.7.1
ENV ROCM_BUILD_NUMBER=74
ENV ROCM_MAJOR_VERSION=5
ENV ROCM_MINOR_VERSION=5
ENV ROCM_PATCH_VERSION=1
ENV ROCM_VERSION=5.5.1
ENV ROCM_PATH=/opt/rocm-5.5.1
ENV PYTORCH_BUILD_VERSION=2.1.2
ENV PYTORCH_BUILD_NUMBER=1
ENV PYTORCH_ROCM_ARCH=gfx803
ENV OPENCV_VERSION=4.8.0.76
ENV USE_FFMPEG=1
ENV USE_CUDA=0 
ENV USE_ROCM=1
ENV USE_NINJA=1

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
    libpng-dev \
    libjpeg-dev \
    libopenmpi3 \
    libstdc++-12-dev \
    libdnnl-dev \
    unzip \
    zip \
    && rm -rf /var/lib/apt/lists/*

RUN pip install astunparse numpy ninja pyyaml setuptools cmake cffi typing_extensions future six requests dataclasses mkl mkl-include

# Build torch 2.1.2
WORKDIR /git
RUN git clone --recursive https://github.com/pytorch/pytorch.git -b v2.1.2

WORKDIR /git/pytorch
RUN pip install -r requirements.txt
RUN ln -s /usr/lib/x86_64-linux-gnu/librt.so.1 /usr/lib/x86_64-linux-gnu/librt.so
RUN python tools/amd_build/build_amd.py
RUN python setup.py bdist_wheel


# Build torchvision 0.16.2
WORKDIR /git
RUN git clone https://github.com/pytorch/vision.git -b v0.16.2

WORKDIR /git/vision
ENV BUILD_VERSION=0.16.2
RUN FORCE_CUDA=1 ROCM_HOME=/opt/rocm-5.5.1/ python setup.py bdist_wheel

WORKDIR /app