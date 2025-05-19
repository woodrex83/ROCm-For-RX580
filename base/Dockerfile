FROM rocm/dev-ubuntu-22.04:6.1.2-complete

ENV MAX_JOBS=8
ENV MAGMA_VERSION="rocm-rel-6.1.2"
ENV HSA_OVERRIDE_GFX_VERSION=8.0.3
ENV ROC_ENABLE_PRE_VEGA=1
ENV ROCM_ARCH=gfx803
ENV HCC_AMDGPU_TARGET=gfx803
ENV PYTORCH_ROCM_ARCH=gfx803
ENV TORCH_BLAS_PREFER_HIPBLASLT=0
ENV USE_CUDA=0
ENV USE_ROCM=1
ENV USE_NINJA=1
ENV FORCE_CUDA=1
ENV ROCBLAS_ROCM_VERSION="rocm-6.1.2"
ENV ROCM_VERSION=6.1.2
ENV CMAKE_ROOT=/usr/local/share/cmake-3.31

LABEL org.opencontainers.image.authors="Patrick Mok <woodrex83@gmail.com>"


# Install all require package
# ffmpeg for SDXL video
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    gfortran \
    git \
    wget \
    ffmpeg \
    virtualenv \
    nano \
    python-is-python3 \
    pkg-config \
    libopenblas-dev \
    ninja-build


# PyTorch cmake configuration fails with CMake 4.0.0
# Install CMake 3.31 from official binary
RUN wget -q https://github.com/Kitware/CMake/releases/download/v3.31.0/cmake-3.31.0-linux-x86_64.sh 

RUN chmod +x cmake-3.31.0-linux-x86_64.sh && \
    ./cmake-3.31.0-linux-x86_64.sh --prefix=/usr/local --exclude-subdir --skip-license && \
    rm cmake-3.31.0-linux-x86_64.sh


# Verify CMake installation
RUN cmake --version


## 1. Build rocBLAS ##
WORKDIR /

RUN git clone https://github.com/ROCm/rocBLAS.git -b ${ROCBLAS_ROCM_VERSION} /rocblas

WORKDIR /rocblas

RUN ./install.sh -ida ${ROCM_ARCH} -j ${MAX_JOBS} -a ${HCC_AMDGPU_TARGET}


## 2. Build Magma ##
WORKDIR /

RUN git clone https://github.com/rocmnavi/magma.git -b ${MAGMA_VERSION} /magma

WORKDIR /magma

RUN cmake \
    -B build \
    -G Ninja \
    -DCMAKE_CXX_COMPILER=/opt/rocm-${ROCM_VERSION}/bin/hipcc \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_SHARED_LIBS=ON \
    -DMAGMA_ENABLE_HIP=ON \
    -DBLA_VENDOR=OpenBLAS \
    -DGPU_TARGET="gfx803"

RUN cmake --build build --target lib sparse-lib

RUN cmake --install build

CMD ["/bin/bash","-c"]