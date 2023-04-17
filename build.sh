#!/bin/bash
make clean && make mrproper && rm -rf out && rm make.txt
mkdir out
export DTC_EXT=dtc
export ARCH=arm64
export SUBARCH=arm64
make O=out ARCH=arm64 SUBARCH=arm64 CROSS_COMPILE=/root/Toolchain/gcc64/bin/aarch64-linux-android- CROSS_COMPILE_COMPAT=/root/Toolchain/gcc32/bin/arm-linux-androideabi- -j$(nproc --all)  vendor/gauguin_user_defconfig 
make CC=clang O=out CROSS_COMPILE=/root/Toolchain/gcc64/bin/aarch64-linux-android- CROSS_COMPILE_COMPAT=/root/Toolchain/gcc32/bin/arm-linux-androideabi- PATH=/root/Toolchain/clang-r383902b/bin:$PATH ARCH=arm64 SUBARCH=arm64 CLANG_TRIPLE=aarch64-linux-gnu- LTO=none -j$(nproc --all) | tee make.txt

if [[ "0" != "$?" ]]; then
        echo -e "${cerror}>>> build kernel error, build stop!${cno}"
        exit 1
fi
echo -e "${cwarn}>>> build kernel success${cno}"
sleep 3s

find out/arch/arm64/boot/dts/vendor/qcom -name '*.dtb' -exec cat {} + > out/arch/arm64/boot/dtb