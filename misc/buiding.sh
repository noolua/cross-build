#!/bin/sh

PACKAGES="zlib lua libuv polarssl curl La-Reale kcore"
test "$2" && PACKAGES="$2"
BUILDING_SHELL=/tmp/building_shell.sh
CP_BUILD=./cp-build
TOOLCHAIN_PATH=$1

building_for_openwrt(){
  local OPENWRT_FIND_GCC=`find $TOOLCHAIN_PATH -name "*linux-gcc"`
  local OPENWRT_PLATFORM=`echo $TOOLCHAIN_PATH|awk -F '/' '{print $(NF);}'`
  local OPENWRT_CROSS_SYSROOT=$(echo $OPENWRT_FIND_GCC|awk -F '/bin/' '{print $1}')
  local OPENWRT_TOOLCHAIN_PATH="${OPENWRT_CROSS_SYSROOT}/bin"
  local OPENWRT_TOOLCHAIN_BIN_PREFIX=$(echo $OPENWRT_FIND_GCC|awk -F '/' '{print $NF}'|awk -F 'gcc' '{print $1}')
  if test x$OPENWRT_PLATFORM=x; then
    OPENWRT_PLATFORM=`echo $TOOLCHAIN_PATH|awk -F '/' '{print $(NF-1);}'`
  fi

cat << END > $BUILDING_SHELL
export TARGET_PLATFORM=${OPENWRT_PLATFORM}
export TOOLCHAIN_PATH=${OPENWRT_TOOLCHAIN_PATH}
export TOOLCHAIN_BIN_PREFIX=${OPENWRT_TOOLCHAIN_BIN_PREFIX}
export CROSS_SYSROOT=${OPENWRT_CROSS_SYSROOT}
export STAGING_DIR=${OPENWRT_CROSS_SYSROOT}
END
}

building_for_android(){

  local NDK_TOOLCHAIN_PATH=${TOOLCHAIN_PATH}/bin
  local NDK_PLATFORM=`echo $TOOLCHAIN_PATH|awk -F '/' '{print $(NF);}'`
  local NDK_TOOLCHAIN_BIN_PREFIX=`ls ${NDK_TOOLCHAIN_PATH}/*gcc|awk -F '/' '{print $NF;}'|awk -F 'gcc' '{print $1}'`
  local NDK_CROSS_SYSROOT=${TOOLCHAIN_PATH}/sysroot
  if test x$NDK_PLATFORM=x; then
    NDK_PLATFORM=`echo $TOOLCHAIN_PATH|awk -F '/' '{print $(NF-1);}'`
  fi

cat << END > $BUILDING_SHELL
export TARGET_PLATFORM=${NDK_PLATFORM}
export TOOLCHAIN_PATH=${NDK_TOOLCHAIN_PATH}
export TOOLCHAIN_BIN_PREFIX=${NDK_TOOLCHAIN_BIN_PREFIX}
export CROSS_SYSROOT=${NDK_CROSS_SYSROOT}
END

}

building_check_toolchains(){
  local TARGET_TYPE="n/a"
  if [ -d "${TOOLCHAIN_PATH}/sysroot/usr/include/android" ]; then
    TARGET_TYPE=android
  fi
  if [ -e "${TOOLCHAIN_PATH}/README.TOOLCHAIN" ] || [ -e "${TOOLCHAIN_PATH}/README.SDK" ]; then
    TARGET_TYPE=openwrt
  fi
  case $TARGET_TYPE in
    android)
      building_for_android
      ;;
    openwrt)
      building_for_openwrt
      ;;
    *)
      rm -f $BUILDING_SHELL
      echo "UNKNOWN TARGET TOOLCHAINS!"
      ;;
  esac
}

building_packages(){
  if [ -e $BUILDING_SHELL ]; then
    . $BUILDING_SHELL
    for package in ${PACKAGES}; do
      ${CP_BUILD} $TARGET_PLATFORM $package
    done
  fi
}

building_check_toolchains
building_packages





