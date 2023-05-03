ARG_UBUNTU_VERSION="20.04"

# ROCm
ARG_ROCM_ARCH="gfx803"
ARG_ROCM_MAJOR_VERSION="5"
ARG_ROCM_MINOR_VERSION="4"
ARG_ROCM_PATCH_VERSION="3"
ARG_ROCM_BUILD_NUMBER="121"
ARG_ROCM_LIBPATCH_VERSION=$(printf "%d%02d%02d" ${ARG_ROCM_MAJOR_VERSION} ${ARG_ROCM_MINOR_VERSION} ${ARG_ROCM_PATCH_VERSION})
ARG_ROCM_VERSION="${ARG_ROCM_MAJOR_VERSION}.${ARG_ROCM_MINOR_VERSION}.${ARG_ROCM_PATCH_VERSION}"

# Magma
ARG_MAGMA_VERSION="2.7.1"

# gfx803
ARG_ROCBLAS_BASE_URL="https://github.com/ulyssesrr/rocm-gfx803/releases/download/rocm-${ARG_ROCM_VERSION}-gfx803"
ARG_ROCBLAS_FILE="rocblas_2.46.0.50403-121.20.04_amd64.deb"
ARG_ROCBLAS_DEV_FILE="rocblas-dev_2.46.0.50403-121.20.04_amd64.deb"

# Python
ARG_PYTHON_VERSION="3.8"
ARG_PYTORCH_VERSION="1.13.1"
ARG_PYTORCH_VISION_VERSION="0.14.1"
ARG_OPENCV_VERSION="4.7.0.72"

# Packages
ARG_GFX803_DIST_BASE_URL="$ARG_ROCBLAS_BASE_URL"
ARG_GFX803_DIST_TORCH_WHEEL="torch-${ARG_PYTORCH_VERSION}-cp38-cp38-linux_x86_64.whl"
ARG_GFX803_DIST_TORCHVISION_WHEEL=torchvision-0.14.1a0+5e8e2f1-cp38-cp38-linux_x86_64.whl

# Build
ARG_NUM_CPU_CORES=$(nproc)

docker_build() {
   docker build \
    --build-arg "UBUNTU_VERSION=$ARG_UBUNTU_VERSION" \
    --build-arg "ROCM_ARCH=$ARG_ROCM_ARCH" \
    --build-arg "ROCM_MAJOR_VERSION=$ARG_ROCM_MAJOR_VERSION" \
    --build-arg "ROCM_MINOR_VERSION=$ARG_ROCM_MINOR_VERSION" \
    --build-arg "ROCM_PATCH_VERSION=$ARG_ROCM_PATCH_VERSION" \
    --build-arg "ROCM_BUILD_NUMBER=$ARG_ROCM_BUILD_NUMBER" \
    --build-arg "ROCM_LIBPATCH_VERSION=$ARG_ROCM_LIBPATCH_VERSION" \
    --build-arg "ROCM_VERSION=$ARG_ROCM_VERSION" \
    --build-arg "MAGMA_VERSION=$ARG_MAGMA_VERSION" \
    --build-arg "ROCBLAS_BASE_URL=$ARG_ROCBLAS_BASE_URL" \
    --build-arg "ROCBLAS_FILE=$ARG_ROCBLAS_FILE" \
    --build-arg "ROCBLAS_DEV_FILE=$ARG_ROCBLAS_DEV_FILE" \
    --build-arg "PYTHON_VERSION=$ARG_PYTHON_VERSION" \
    --build-arg "PYTORCH_VERSION=$ARG_PYTORCH_VERSION" \
    --build-arg "PYTORCH_VISION_VERSION=$ARG_PYTORCH_VISION_VERSION" \
    --build-arg "OPENCV_VERSION=$ARG_OPENCV_VERSION" \
    --build-arg "GFX803_DIST_BASE_URL=$ARG_GFX803_DIST_BASE_URL" \
    --build-arg "GFX803_DIST_TORCH_WHEEL=$ARG_GFX803_DIST_TORCH_WHEEL" \
    --build-arg "GFX803_DIST_TORCHVISION_WHEEL=$ARG_GFX803_DIST_TORCHVISION_WHEEL" \
    --build-arg "NUM_CPU_CORES=$ARG_NUM_CPU_CORES" \
    "$@"
}