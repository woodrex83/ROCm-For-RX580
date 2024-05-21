FROM pytorch-for-gfx803-dev:latest
ENV ROCM_VERSION=5.5.1

LABEL org.opencontainers.image.authors="Patrick Mok <woodrex83@gmail.com>"

# Build torchvision
WORKDIR /git
RUN git clone https://github.com/pytorch/vision.git -b v0.16.2

# Build torchvision wheel
WORKDIR /git/vision
ENV ROCM_HOME=/opt/rocm-${ROCM_VERSION}
ENV BUILD_VERSION=0.16.2
RUN FORCE_CUDA=1 \
    TORCHVISION_USE_NVJPEG=0 \
    TORCHVISION_USE_VIDEO_CODEC=0 \
    TORCHVISION_USE_FFMPEG=1 \
    python setup.py bdist_wheel
RUN pip install --no-cache-dir /git/vision/dist/torchvision-*.whl

RUN rm -f /git/vision/dist/torchvision-*.whl

WORKDIR /app