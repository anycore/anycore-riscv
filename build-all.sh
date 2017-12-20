#! /bin/bash
# Script to build RISC-V ISA simulator, proxy kernel, and RISC-V DPI code required for RTL simulations.

# This file uses source code from the University of Berkeley RISC-V project 
# in original or modified form.
# Please see LICENSE for details.


### If using NCSU RHEL-6 machine
source scl_source enable devtoolset-3

#Path to the directory where the compiled RISC-V tools should be installed
RISCV_INSTALL=$PWD/install

### Set the correct compiler path if using a custom GCC build
#GCC_PATH=/ece/ericro/common/gcc492_64
#GCC_SUFFIX=492

#export CC=$GCC_PATH/bin/gcc$GCC_SUFFIX
#export CXX=$GCC_PATH/bin/g++$GCC_SUFFIX
#export LD=$GCC_PATH/bin/ld$GCC_SUFFIX
#export AR=$GCC_PATH/bin/ar$GCC_SUFFIX
#export RANLIB=$GCC_PATH/bin/ranlib$GCC_SUFFIX
#export LDFLAGS="-L$GCC_PATH/lib64"
##export LD_LIBRARY_PATH="$GCC_PATH/lib64"

#CFLAGS="-g -O0"
#CXXFLAGS="-g -O0"
#
#export CFLAGS
#export CXXFLAGS

. build.common

if [ ! `which riscv64-unknown-elf-gcc` ]
then
  echo "riscv64-unknown-elf-gcc doesn't appear to be installed; use the build-gcc.sh to build and install it."
  exit 1
fi

echo "Starting RISC-V Toolchain build process"

build_project riscv-fesvr --prefix=$RISCV_INSTALL
#build_project riscv-isa-sim --prefix=$RISCV_INSTALL --with-fesvr=$RISCV_INSTALL 
#build_project riscv-isa-sim --prefix=$RISCV_INSTALL --with-fesvr=$RISCV_INSTALL --enable-simpoint
CC=riscv64-unknown-elf-gcc CFLAGS="-msoft-float" ASFLAGS="-msoft-float" build_project riscv-pk --prefix=$RISCV_INSTALL/riscv64-unknown-elf --host=riscv --disable-atomics
#build_project riscv-dpi --prefix=$RISCV_INSTALL --with-fesvr=$RISCV_INSTALL --enable-checker 
#build_project riscv-dpi --prefix=$RISCV_INSTALL --with-fesvr=$RISCV_INSTALL --enable-checker --enable-micro-debug


echo -e "\\nRISC-V Toolchain installation completed!"
