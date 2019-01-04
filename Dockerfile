FROM ubuntu:latest

RUN apt update && \
  apt upgrade -y && \
  apt install -y automake bc bison binutils-aarch64-linux-gnu binutils-arm-linux-gnueabi ccache lzop flex gperf build-essential \
  zip curl zlib1g-dev gcc-7-aarch64-linux-gnu gcc-arm-linux-gnueabi gcc-aarch64-linux-gnu python-networkx libxml2-utils \
  bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool \
  lib32ncurses5-dev lib32z-dev dpkg-dev libssl-dev liblz4-tool make optipng && \
  apt-get autoremove && \
  apt clean

ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-
ENV CROSS_COMPILE_ARM32=arm-linux-gnueabi-
ENV USE_CCACHE=1
ENV LC_ALL=C
ENV ANDROID_JACK_VM_ARGS="-Xmx8g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"

COPY . /src

WORKDIR /src

CMD ["sh", "-c", "make elementalx_defconfig && make -j$(nproc)"]
