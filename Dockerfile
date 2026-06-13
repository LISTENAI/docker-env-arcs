# syntax=docker/dockerfile:1

FROM ubuntu:22.04 AS toolchain

RUN <<EOF
set -eux
apt-get update
apt-get install -y --no-install-recommends bzip2 ca-certificates wget
rm -rf /var/lib/apt/lists/*
mkdir -p /opt/arcs
cd /opt/arcs
wget https://listenai-firmware-delivery.oss-cn-beijing.aliyuncs.com/ARCS/tools/toolchain/linux-amd64/nuclei_riscv_newlibc_prebuilt_linux64_2025.02.tar.bz2 \
    -O /tmp/nuclei_riscv_newlibc_prebuilt_linux64_2025.02.tar.bz2
tar xf /tmp/nuclei_riscv_newlibc_prebuilt_linux64_2025.02.tar.bz2
rm /tmp/nuclei_riscv_newlibc_prebuilt_linux64_2025.02.tar.bz2
EOF


FROM ubuntu:22.04 AS tools

RUN <<EOF
set -eux
apt-get update
apt-get install -y --no-install-recommends bzip2 ca-certificates wget
rm -rf /var/lib/apt/lists/*
mkdir -p /opt/arcs
cd /opt/arcs
wget http://listenai-firmware-delivery.oss-cn-beijing.aliyuncs.com/ARCS/tools/dev-tools/linux-amd64/v0.0.1/listenai-tools.tar.gz \
    -O /tmp/listenai-tools.tar.gz
tar xf /tmp/listenai-tools.tar.gz
rm /tmp/listenai-tools.tar.gz
EOF


FROM ubuntu:22.04

RUN <<EOF
set -eux
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake \
    git \
    git-lfs \
    libncursesw5 \
    libtinfo5 \
    make \
    ninja-build \
    python3 \
    xxd
rm -rf /var/lib/apt/lists/*
EOF

COPY --link --from=toolchain /opt/arcs/gcc /opt/arcs/gcc
COPY --link --from=tools /opt/arcs/listenai-tools /opt/arcs/listenai-tools

ENV LISTENAI_TOOLS_PATH=/opt/arcs/listenai-tools \
    NUCLEI_TOOLCHAIN_PATH=/opt/arcs/gcc \
    PATH=/opt/arcs/gcc/bin:${PATH}
