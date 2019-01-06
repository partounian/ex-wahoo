FROM ubuntu:latest

RUN apt update && \
  apt upgrade -y && \
  apt install -y automake bc build-essential bzip2 ccache curl dpkg-dev git gperf \
  libghc-bzlib-dev libncurses-dev libz-dev libssl-dev liblz4-tool \
  make pngquant python-networkx schedtool squashfs-tools zlib1g && \
  apt-get autoremove && \
  apt clean

RUN mkdir /toolchain && cd /toolchain \
  mkdir -p prebuilts/gcc/linux-x86/aarch64/ prebuilts/gcc/linux-x86/arm/ \
  prebuilts-master/clang/host/linux-x86/ prebuilts-master/misc/linux-x86/ && \
  git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 && \
  git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 && \
  git clone -b android-9.0.0_r22 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 prebuilts-master/clang/host/linux-x86 && \
  git clone https://android.googlesource.com/platform/external/lz4 prebuilts-master/misc/linux-x86/lz4 && \
  git clone https://android.googlesource.com/platform/external/dtc prebuilts-master/misc/linux-x86/dtc && \
  git clone https://android.googlesource.com/platform/system/libufdt prebuilts-master/misc/linux-x86/libufdt

ENV USE_CCACHE=1
ENV ANDROID_JACK_VM_ARGS="-Xmx12g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"

WORKDIR /src

CMD ["bash", "-c", "set -o allexport && source build.config.clang.lto && make $DEFCONFIG && source .config && make -j$(nproc --all)"]
