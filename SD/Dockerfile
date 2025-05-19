FROM woodrex/rocm612-torch24-gfx803

ENV HSA_OVERRIDE_GFX_VERSION=8.0.3
ENV PYTORCH_ROCM_ARCH=gfx803
ENV PYTHONUNBUFFERED=1

WORKDIR /stable-diffusion-webui

RUN git clone https://github.com/woodrex83/stable-diffusion-webui-rx580.git .

RUN pip install -r requirements_versions.txt

ENTRYPOINT ["python", "launch.py",  "--listen", "--medvram"]
# ENTRYPOINT ["python", "launch.py", "--api", "--listen", "--no-half", "--precision", "full", "--opt-sdp-attention", "--medvram"]