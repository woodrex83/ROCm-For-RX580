# Rocm-for-gfx803

This repo hosts the docker images with ROCm backend support for extra architectures.
*Mainly focus on gfx803.*
However only the `Radeon RX 580 2048SP` is currently tested.
Since 2048SP is same as RX570, RX570/580/590 should work normally

# Acknowledgements
Based on the packages built by https://github.com/xuhuisheng/rocm-gfx803

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

# Usage

## Recommended aliases

+ ~55GB space is required for both rocm and pytorch image here

```shell
# Do not use it on produtcion environment
alias drun='sudo docker run -it --network=host --device=/dev/kfd --device=/dev/dri --ipc=host --shm-size 16G --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v $(pwd):/current'

# rocm 5.5.1 only
cd rocm-for-grx803
docker build -t rocm-for-grx803:latest .
drun --rm rocm-for-gfx803

# pytorch with rocm 5.5.1
cd pytorch-for-gfx803
docker build -t pytorch-for-gfx803:latest .
drun --rm pytorch-for-gfx803
```

## Version
+ Ubuntu: `22.04`
+ Python: `3.10`
+ ROCm: `5.5.1`
+ Torch: `2.0.1`
+ Torchvision: `0.15.2`
+ Torchaudio: `2.0.2`
+ opencv: `4.8.0.76`