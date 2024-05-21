FROM rocm/dev-ubuntu-22.04:5.5.1-complete

ENV UBUNTU_VERSION=22.04
ENV MAGMA_VERSION=2.7.1
ENV ROCM_BUILD_NUMBER=74
ENV ROCM_MAJOR_VERSION=5
ENV ROCM_MINOR_VERSION=5
ENV ROCM_PATCH_VERSION=1
ENV ROCM_LIBPATCH_VERSION=50501
ENV ROCM_PKGTYPE=DEB
ENV ROCM_VERSION=5.5.1
ENV CPACK_DEBIAN_PACKAGE_RELEASE=${ROCM_BUILD_NUMBER}~${UBUNTU_VERSION}
ENV ROCM_PATH=/opt/rocm-5.5.1

LABEL org.opencontainers.image.author="Patrick Mok <woodrex83@gmail.com>"

WORKDIR /src
# Download deps
RUN --mount=type=cache,target=/var/cache/apt,rw --mount=type=cache,target=/var/lib/apt,rw \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gfortran \
    git \
    python-is-python3 \
    nano \
    wget \
    make \
    pkg-config \
    libnuma1 \
    cmake \
    libopenblas-dev \
    ninja-build

# Download rocBLAS
RUN --mount=type=cache,target=/tmp/cache/download,rw \
    curl -L -o /tmp/cache/download/rocBLAS-${ROCM_VERSION}.tar.gz https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${ROCM_VERSION}.tar.gz \
    && tar -xf /tmp/cache/download/rocBLAS-${ROCM_VERSION}.tar.gz -C /src \
    && rm -f /tmp/cache/download/rocBLAS-${ROCM_VERSION}.tar.gz

# Download tensile
RUN --mount=type=cache,target=/tmp/cache/download,rw \
    curl -L -o /tmp/cache/download/Tensile-${ROCM_VERSION}.tar.gz https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${ROCM_VERSION}.tar.gz \
    && tar -xvf /tmp/cache/download/Tensile-${ROCM_VERSION}.tar.gz -C /src \
    && rm -f /tmp/cache/download/Tensile-${ROCM_VERSION}.tar.gz

# gfx803 fix
RUN rm -rf /src/rocBLAS-rocm-${ROCM_VERSION}/library/src/blas3/Tensile/Logic/asm_full/r9nano*

# Download rocSPARSE
RUN --mount=type=cache,target=/tmp/cache/download,rw \
    curl -L -o /tmp/cache/download/rocSPARSE-${ROCM_VERSION}.tar.gz https://github.com/ROCmSoftwarePlatform/rocSPARSE/archive/rocm-${ROCM_VERSION}.tar.gz \
    && tar -xf /tmp/cache/download/rocSPARSE-${ROCM_VERSION}.tar.gz -C /src \
    && rm -f /tmp/cache/download/rocSPARSE-${ROCM_VERSION}.tar.gz

# Download Magma
RUN --mount=type=cache,target=/tmp/cache/download,rw \
    wget -O /tmp/cache/download/magma-${MAGMA_VERSION}.tar.gz https://icl.utk.edu/projectsfiles/magma/downloads/magma-${MAGMA_VERSION}.tar.gz \
    && tar -xf /tmp/cache/download/magma-${MAGMA_VERSION}.tar.gz -C /src \
    && rm -f /src/magma-${MAGMA_VERSION}.tar.gz

# Build and make rocBLAS, Tensile
WORKDIR /src/rocBLAS-rocm-${ROCM_VERSION}

COPY patches /patches
RUN patch -Np1 -d /src/Tensile-rocm-${ROCM_VERSION} -i /patches/Tensile-fix-fallback-arch-build.patch
RUN patch -Np1 -d /src/rocBLAS-rocm-${ROCM_VERSION} -i /patches/rocBLAS-configure-but-dont-build.patch
RUN --mount=type=cache,target=/var/cache/apt,rw --mount=type=cache,target=/var/lib/apt,rw \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cmake \
    && DEBIAN_FRONTEND=noninteractive ./install.sh \
        --cmake_install \
        --dependencies \
        --test_local_path /src/Tensile-rocm-${ROCM_VERSION} \
        --architecture "gfx803" \
        --logic asm_full \
        --msgpack \
    && rm -rf /var/lib/apt/lists/*
RUN make -C build/release -j$(nproc) TENSILE_LIBRARY_TARGET

# Build and make rocSPARSE
WORKDIR /src/rocSPARSE-rocm-${ROCM_VERSION}

RUN cmake \
    -Wno-dev \
    -B build \
    -S "/src/rocSPARSE-rocm-${ROCM_VERSION}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=/opt/rocm-${ROCM_VERSION}/bin/hipcc \
    -DCMAKE_CXX_COMPILER=/opt/rocm-${ROCM_VERSION}/bin/hipcc \
    -DCMAKE_INSTALL_PREFIX=/opt/rocm-${ROCM_VERSION} \
    -DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=ON \
    -DCPACK_SET_DESTDIR=OFF \
    -DCPACK_PACKAGING_INSTALL_PREFIX=/opt/rocm-${ROCM_VERSION} \
    -DROCM_PATH="${ROCM_PATH}" \
    -DAMDGPU_TARGETS="gfx803"

RUN cmake --build build --target package -j$(nproc)

WORKDIR /deb

# Download original rocBLAS package
RUN --mount=type=cache,target=/var/cache/apt,rw --mount=type=cache,target=/var/lib/apt,rw \
    apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get download rocblas \
    && rm -rf /var/lib/apt/lists/*

# Extract original deb
RUN mkdir extracted && dpkg-deb -R /deb/rocblas_*.deb extracted

# Remove broken gfx803 libraries
RUN rm -rf /deb/extracted/opt/rocm-${ROCM_VERSION}/lib/rocblas/library/*gfx803*

# Add libraries from package
RUN cp /src/rocBLAS-rocm-${ROCM_VERSION}/build/release/Tensile/library/* /deb/extracted/opt/rocm-${ROCM_VERSION}/lib/rocblas/library/

# Overwrite original .deb and delete extracted files
RUN chmod 0755 /deb/extracted/DEBIAN/* \
    && dpkg-deb -Zxz -b extracted /deb/rocblas_*.deb \
    && rm -rf /deb/extracted

RUN mkdir /tmp/rocblas
RUN mkdir /tmp/rocsparse

# Move rocBLASE to tmp
RUN mv /deb/*.deb /tmp/rocblas

# Move rocSPARSE to tmp
RUN mv /src/rocSPARSE-rocm-${ROCM_VERSION}/build/*.deb  /tmp/rocsparse

# Install rocblas
WORKDIR /tmp/rocblas
RUN dpkg -i /tmp/rocblas/*.deb \
    && rm -f /tmp/rocblas/*.deb

# Install rocsparse
WORKDIR /tmp/rocsparse
RUN dpkg -i /tmp/rocsparse/*.deb \
    && rm -f /tmp/rocsparse/*.deb

# Make and Install Magma
WORKDIR /src/magma-${MAGMA_VERSION}

# GPU Target selected all arch here
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

WORKDIR /app