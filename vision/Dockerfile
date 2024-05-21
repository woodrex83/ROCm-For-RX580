FROM pytorch-for-gfx803-dev:latest
ENV ROCM_VERSION=5.5.1

LABEL org.opencontainers.image.authors="Patrick Mok <woodrex83@gmail.com>"

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

RUN rm -f /git/vision/dist/torchvision-*.whl

WORKDIR /app