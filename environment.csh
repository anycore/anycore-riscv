# This set of setenv commands establishes the devtoolset-3 which contains
# newer versions of GCC and associated tools. This is required for compiling
# C++11 used in the simulators and DPI code.
setenv PATH /opt/rh/devtoolset-3/root/usr/bin:${PATH}
setenv MANPATH /opt/rh/devtoolset-3/root/usr/share/man
setenv INFOPATH /opt/rh/devtoolset-3/root/usr/share/info
setenv JAVACONFDIRS "/opt/rh/devtoolset-3/root/etc/java"
setenv XDG_DATA_DIRS "/opt/rh/devtoolset-3/root/usr/share"
setenv LD_LIBRARY_PATH /opt/rh/devtoolset-3/root
