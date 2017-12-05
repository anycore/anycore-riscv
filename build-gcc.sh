#! /bin/bash
# Script to build RISC-V ISA simulator, proxy kernel, and RISC-V DPI code required for RTL simulations.

# This file uses source code from the University of Berkeley RISC-V project 
# in original or modified form.
# Please see LICENSE for details.


### If using NCSU RHEL-6 machine
#source scl_source enable devtoolset-3

#Path to the directory where the compiled RISC-V GCC should be installed
RISCV_GCC_INSTALL=$PWD/install

### Set the correct compiler path if using a custom GCC build
#GCC_PATH=/afs/eos.ncsu.edu/lockers/research/ece/ericro/common/gcc492_64
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

if [ ! `which riscv64-unknown-elf-gcc` ]
echo "Starting RISC-V GNU Toolchain build process"

build_project riscv-gnu-toolchain --prefix=$RISCV_GCC_INSTALL


echo -e "\\nRISC-V GNU Toolchain installation completed!"
