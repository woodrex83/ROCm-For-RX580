FROM woodrex/rocm612-gfx803:latest

ENV PYTORCH_GIT_VERSION="release/2.4"
ENV VISION_GIT_VERSION="release/0.20"
ENV AUDIO_GIT_VERSION="v2.4.0"
ENV PYTHONUNBUFFERED=1
ENV PYTHONENCODING=UTF-8

ENV HSA_OVERRIDE_GFX_VERSION=8.0.3
ENV TORCH_BLAS_PREFER_HIPBLASLT=0
ENV ROC_ENABLE_PRE_VEGA=1
ENV USE_CUDA=0
ENV USE_ROCM=1
ENV FORCE_CUDA=1
ENV USE_NINJA=1
ENV USE_FFMPEG=1
ENV MAX_JOBS=8
ENV PYTORCH_ROCM_ARCH=gfx803
ENV ROCM_ARCH=gfx803
ENV CMAKE_ROOT=/usr/local/share/cmake-3.31

LABEL org.opencontainers.image.authors="Patrick Mok <woodrex83@gmail.com>"

# Build torch
WORKDIR /
RUN git clone --recursive https://github.com/pytorch/pytorch.git -b ${PYTORCH_GIT_VERSION} /pytorch

# Build torch wheel
WORKDIR /pytorch

RUN dpkg -r --force-depends python3-yaml python3-filelock && \
    mkdir -p /pytorch/dist

RUN sed -i 's/^cmake$/cmake==3.31/' requirements.txt

RUN python setup.py clean && \
    pip install --no-cache-dir -r requirements.txt

RUN python tools/amd_build/build_amd.py

RUN python setup.py bdist_wheel --verbose

RUN pip install --no-cache-dir dist/torch*.whl && \
    rm -rf /pytorch/dist/*.whl

# Build torchvision
WORKDIR /
RUN git clone https://github.com/pytorch/vision.git -b ${VISION_GIT_VERSION} /vision

# Build torchvision wheel
WORKDIR /vision
RUN python setup.py bdist_wheel

RUN pip install --no-cache-dir dist/torchvision-*.whl && \
    mkdir -p /vision/dist

# Build torchaudio
WORKDIR /
RUN git clone https://github.com/pytorch/audio.git -b ${AUDIO_GIT_VERSION} /audio

# Build audio wheel
WORKDIR /audio
RUN python setup.py bdist_wheel
RUN pip install --no-cache-dir dist/*.whl

CMD ["/bin/bash","-c"]