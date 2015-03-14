#!/bin/sh

PREFIX=x86_64-linux-gnu-
TOOLCHAIN_BIN_DIR=/usr/bin

(cd $TOOLCHAIN_BIN_DIR && \
for bin in cpp g++ gcc ar as ld nm gfortran ranlib readelf strip objcopy objdump
do
	if [[ ! -f $PREFIX$bin ]] ; then
		#echo "not exist $PREFIX$bin"
		if [[ -f "$bin" ]]; then
			echo "ln -sf $bin $PREFIX$bin"
			ln -sf $bin $PREFIX$bin
		fi
	fi
done)
