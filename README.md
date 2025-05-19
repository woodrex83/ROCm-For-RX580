# ROCm-For-RX580

> [!NOTE]
> #### This repo hosts an *unofficial* docker images with ROCm backend support for extra architectures.

> [!NOTE]
> Only `Radeon RX` and `R9 Fury` is currently tested. RX460/470/480/570/580/590 and R9 should work normally.

> [!CAUTION]
> #### Prevent ROCm SegFaults on your Linux Distro
> According to [gfx803_rocm](https://github.com/robertrosenbusch/gfx803_rocm), Linux-Kernel-Versions 6.12 and 6.13 crashed with SegFaults

## Version
```
Ubuntu 22.04 

ROCm 6.1.2
Python 3.10
Pytorch 2.4.0
```

Image | Description 
--- | ---
[woodrex/rocm612-gfx803](https://hub.docker.com/r/woodrex/rocm612-gfx803) | Base image with ROCm 6.1.2 (including rocBLAS 6.3.3) 
[woodrex/rocm612-torch24-gfx803](https://hub.docker.com/r/woodrex/rocm612-torch24-gfx803) | Images for PyTorch with ROCm backend support
[woodrex/rocm612-torch24-sd-webui-gfx803](https://hub.docker.com/r/woodrex/rocm612-torch24-sd-webui-gfx803)

---

## Recommended aliases

+ 80GB volume is preferred for pytorch/Stable-Diffusion.
+ 30GB volume is preferred for ROCm only.

## Run SD container 
```shell
cd SD
sudo docker compose build
sudo docker compose up

# Stop container
sudo docker compose down
```

## Supported
    Fiji
        Fiji XT
            Radeon Instinct MI8
            Radeon R9 Fury X (Tested)
            Radeon R9 Fury (Tested)
            Radeon R9 Nano 
        Capsaicin XT (Not Confirm)
            FirePro S9300x2 
            Radeon Pro Duo 2016
    Polaris 30
        Radeon RX 590 (Tested)
    Polaris 20
        Radeon Pro 580 (Tested)
        Radeon RX 580 (Tested)
        Radeon Pro 575
        Radeon Pro 570
        Radeon RX 570 (Tested)
    Polaris 10
        Radeon Instinct MI6
        Radeon Pro Duo 2017
        Radeon Pro WX 7100
        Radeon Pro WX 7100 Mobile
        Radeon RX 480 (Tested)
        Radeon Pro WX 5100
        Radeon RX 470 (Tested)
    Polaris 21
        Radeon Pro 560X
        Radeon Pro 560 (Tested)
        Radeon Pro 555X
        Radeon Pro 555
    Polaris 11
        Radeon Pro WX 4100
        Radeon Pro WX 4170 Mobile
        Radeon Pro WX 4150 Mobile
        Radeon Pro WX 4130 Mobile
        Radeon RX 560D
        Radeon RX 460 (Tested)
