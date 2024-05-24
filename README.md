# ROCm-For-RTX580

This repo hosts the docker images with ROCm backend support for extra architectures.
*Mainly focus on gfx803.*
However only the `Radeon RX 580 2048SP` is currently tested.
Since 2048SP is same as RX570, RX570/580/590 should work normally

## Version
```
Ubuntu 22.04
ROCm 5.5

Python 3.10
- pytorch 2.1.2
- torchvision 0.16.2
```

Image | Description 
--- | ---
[woodrex/rocm-for-gfx803-dev](https://hub.docker.com/r/woodrex/rocm-for-gfx803-dev) | Base image with ROCm 5.5 (including rocBLAS and MAGMA) 
[woodrex/pytorch-for-gfx803-dev](https://hub.docker.com/r/woodrex/pytorch-for-gfx803-dev) | Images for PyTorch with ROCm backend support
[woodrex/sd-webui-for-gfx803](https://hub.docker.com/r/woodrex/sd-webui-for-gfx803) | Images for SD

# Reference
- https://github.com/RadeonOpenCompute/ROCm/issues/1659
- https://github.com/xuhuisheng/rocm-gfx803
- https://github.com/xuhuisheng/rocm-gfx803/issues/27#issuecomment-1534048619
- https://github.com/Tokoshie/pytorch-gfx803/releases/tag/v2.1.0a0
- https://github.com/xuhuisheng/rocm-gfx803/issues/27#issuecomment-1892611849
- https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki


# gfx803 Cards
    Fiji
        Fiji XT
            Radeon Instinct MI8
            Radeon R9 Fury X
            Radeon R9 Fury
            Radeon R9 Nano
        Capsaicin XT
            FirePro S9300x2
            Radeon Pro Duo 2016
    Polaris 30
        Radeon RX 590
    Polaris 20
        Radeon Pro 580
        Radeon RX 580
        Radeon Pro 575
        Radeon Pro 570
        Radeon RX 570
    Polaris 10
        Radeon Instinct MI6
        Radeon Pro Duo 2017
        Radeon Pro WX 7100
        Radeon Pro WX 7100 Mobile
        Radeon RX 480
        Radeon Pro WX 5100
        Radeon RX 470
    Polaris 21
        Radeon Pro 560X
        Radeon Pro 560
        Radeon Pro 555X
        Radeon Pro 555
    Polaris 11
        Radeon Pro WX 4100
        Radeon Pro WX 4170 Mobile
        Radeon Pro WX 4150 Mobile
        Radeon Pro WX 4130 Mobile
        Radeon RX 560D
        Radeon RX 460


# Recommended aliases

+ >30GB volume is preferred for pytorch/Stable-Diffusion
+ >20GB volume is preferred for ROCm 5.5 only

## Run SD container 
```shell
# Only use in development environment
# dockerx pointed to docker mounted storage
alias drun='sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --ipc=host --shm-size 16G --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $HOME/dockerx:/dockerx -v $(pwd):/current'

cd SD-webui

# Add --medvram if it is 8GB VRAM or lower
drun --rm -v $(pwd)/cache:/root/.cache \
    -v $(pwd)/data:/stable-diffusion-webui/data \
    -v $(pwd)/outputs:/stable-diffusion-webui/outputs \
    woodrex/sd-webui-for-gfx803:1.0.0
```
