FROM woodrex/pytorch-for-gfx803-dev:1.0.0

WORKDIR /git
RUN git clone https://github.com/woodrex83/stable-diffusion-webui-rx580.git
RUN pip install -r /git/stable-diffusion-webui-rx580/requirements_versions.txt

WORKDIR /git/stable-diffusion-webui-rx580
VOLUME /root/.cache
RUN mkdir -p /stable-diffusion-webui/data
VOLUME /stable-diffusion-webui/data
VOLUME /stable-diffusion-webui/outputs

ENV PYTHONUNBUFFERED=1

ENTRYPOINT ["python", "launch.py", "--data-dir", "/stable-diffusion-webui/data", "--listen"]