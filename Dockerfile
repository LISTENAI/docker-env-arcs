# syntax=docker/dockerfile:1

FROM ubuntu:24.04

RUN <<EOF
set -eux

apt-get update
apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    git \
    wget
rm -rf /var/lib/apt/lists/*

mkdir -p /opt/arcs
cd /opt/arcs

wget http://listenai-firmware-delivery.oss-cn-beijing.aliyuncs.com/ARCS/tools/dev-tools/linux-amd64/v0.0.1/listenai-tools.tar.gz \
    -O /tmp/listenai-tools.tar.gz
tar xf /tmp/listenai-tools.tar.gz
rm /tmp/listenai-tools.tar.gz

wget https://listenai-firmware-delivery.oss-cn-beijing.aliyuncs.com/ARCS/tools/toolchain/linux-amd64/nuclei_riscv_newlibc_prebuilt_linux64_2025.02.tar.bz2 \
    -O /tmp/nuclei_riscv_newlibc_prebuilt_linux64_2025.02.tar.bz2
tar xf /tmp/nuclei_riscv_newlibc_prebuilt_linux64_2025.02.tar.bz2
rm /tmp/nuclei_riscv_newlibc_prebuilt_linux64_2025.02.tar.bz2
EOF

ENV LISTENAI_TOOLS_PATH=/opt/arcs/listenai-tools \
    NUCLEI_TOOLCHAIN_PATH=/opt/arcs/gcc
