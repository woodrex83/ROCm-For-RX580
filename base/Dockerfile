FROM rocm/dev-ubuntu-22.04:6.3.4-complete

ENV MAX_JOBS=8
ENV HSA_OVERRIDE_GFX_VERSION=8.0.3
ENV ROC_ENABLE_PRE_VEGA=1
ENV ROCM_ARCH=gfx803
ENV ROCBLAS_VERSION="rocm-6.3.0"
ENV HCC_AMDGPU_TARGET=gfx803
ENV PYTORCH_ROCM_ARCH=gfx803
ENV TORCH_BLAS_PREFER_HIPBLASLT=0
ENV USE_CUDA=0
ENV USE_ROCM=1
ENV USE_NINJA=1
ENV FORCE_CUDA=1
ENV ROCBLAS_ROCM_VERSION="rocm-6.3.3"
ENV CMAKE_ROOT=/usr/local/share/cmake-3.31

LABEL org.opencontainers.image.authors="Patrick Mok <woodrex83@gmail.com>"

# Install all require package
# ffmpeg for SDXL video
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
    git \
    wget \
    ffmpeg \
    virtualenv \
    nano \
    python-is-python3

# PyTorch cmake configuration fails with CMake 4.0.0
# Install CMake 3.31 from official binary
RUN wget -q https://github.com/Kitware/CMake/releases/download/v3.31.0/cmake-3.31.0-linux-x86_64.sh 

RUN chmod +x cmake-3.31.0-linux-x86_64.sh && \
    ./cmake-3.31.0-linux-x86_64.sh --prefix=/usr/local --exclude-subdir --skip-license && \
    rm cmake-3.31.0-linux-x86_64.sh

# Verify CMake installation
RUN cmake --version

# Build rocBLAS
RUN git clone https://github.com/ROCm/rocBLAS.git -b ${ROCBLAS_ROCM_VERSION} /rocblas

WORKDIR /rocblas

RUN ./install.sh -ida ${ROCM_ARCH} -j ${MAX_JOBS} -a ${HCC_AMDGPU_TARGET}

CMD ["/bin/bash","-c"]