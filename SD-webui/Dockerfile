FROM woodrex/pytorch-for-gfx803-dev:1.0.0

WORKDIR /git
RUN git clone https://github.com/woodrex83/stable-diffusion-webui-rx580.git

WORKDIR /git/stable-diffusion-webui
RUN pip install -r requirements_versions.txt
ENV ROOT=/stable-diffusion-webui
RUN python launch.py --listen