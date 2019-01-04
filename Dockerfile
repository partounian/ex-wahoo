FROM ubuntu:latest

WORKDIR /src

RUN apt update && \
  apt upgrade -y && \
  apt install -y automake bc bison ccache lzop flex gperf build-essential \
  zip curl zlib1g-dev git libxml2-utils bzip2 libbz2-dev libbz2-1.0 \
  libghc-bzlib-dev squashfs-tools pngcrush python-networkx schedtool \
  lib32ncurses5-dev lib32z-dev dpkg-dev libssl-dev liblz4-tool make optipng && \
  apt-get autoremove && \
  apt clean

RUN mkdir -p prebuilts/gcc/linux-x86/aarch64/ prebuilts/gcc/linux-x86/arm/ \
  prebuilts-master/clang/host/linux-x86/ prebuilts-master/misc/linux-x86/ && \
  git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 && \
  git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 && \
  git clone -b android-9.0.0_r22 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 prebuilts-master/clang/host/linux-x86 && \
  git clone https://android.googlesource.com/platform/external/lz4 prebuilts-master/misc/linux-x86/lz4 && \
  git clone https://android.googlesource.com/platform/external/dtc prebuilts-master/misc/linux-x86/dtc && \
  git clone https://android.googlesource.com/platform/system/libufdt prebuilts-master/misc/linux-x86/libufdt

ENV USE_CCACHE=1
ENV ANDROID_JACK_VM_ARGS="-Xmx8g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"

COPY . /src

CMD ["bash", "-c", "set -o allexport && source build.config.clang.lto && make $DEFCONFIG && make -j$(nproc)"]
