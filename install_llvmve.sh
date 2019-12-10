#!/usr/bin/env bash

WGET="wget --connect-timeout=5 --tries=3"
RPM=rpm
RPM_CPIO=rpm2cpio
CPIO=cpio

LLVM_VE_VERSION=1.4.0
LLVM_VE_RC=1
RELEASE_TAG=llvm-ve-rv-v${LLVM_VE_VERSION}

RELEASE_BASE_URL=https://github.com/sx-aurora-dev/llvm-project/releases/download/
RPM_FILE=llvm-ve-rv-${LLVM_VE_VERSION}-${LLVM_VE_VERSION}-${LLVM_VE_RC}.x86_64.rpm
RELEASE_SUFFIX=${RELEASE_TAG}/${RPM_FILE}
RELEASE_URL=${RELEASE_BASE_URL}/${RELEASE_SUFFIX}

RPM_PATH=${PWD}/${RPM_FILE}
RPM_INTERNAL_PREFIX="opt/nec/nosupport/llvm-ve-rv-${LLVM_VE_VERSION}"

# Info
echo "---------------------------------------------"
echo "     Installer for local LLVM-VE ${LLVM_VE_VERSION}"
echo "---------------------------------------------"

# Download
if ! ${RPM} -K --nosignature ${RPM_PATH} 2> /dev/null | grep -s OK - > /dev/null; then
  echo "Downloading release ${RELEASE_SUFFIX} to ${RPM_PATH}"
  if ! ${WGET} -c -o wget.log -O ${RPM_PATH} ${RELEASE_URL}; then
    echo "Could not download ${RELEASE_URL}!"
    echo "Wget log written to 'wget.log'"
    exit 1
  fi

  # Verify integrity
  if ! ${RPM} -K --nosignature ${RPM_PATH} 2> /dev/null | grep -s OK - > /dev/null; then
    echo "Corrupted archive (${RPM_PATH})!"
    exit 2
  fi
fi

echo "Verified RPM checksum!"

# Read install prefix
DEFAULT_PREFIX="${PWD}/install"
read -i ${DEFAULT_PREFIX} -p "Install prefix (Leave empty for ${DEFAULT_PREFIX}): " PREFIX
PREFIX=${PREFIX:-${DEFAULT_PREFIX}}


# Unpack
echo "::: Installing to ${PREFIX} :::"
OLD_PWD=${PWD}

mkdir -p ${PREFIX}
cd ${PREFIX}

if ! ${RPM_CPIO} "${RPM_PATH}" | ${CPIO} -duim --quiet; then
  echo "An error occured while trying to extract the RPM file. Aborting!"
  exit 3
fi

mv ${RPM_INTERNAL_PREFIX}/* .
cd ${OLD_CWD}

echo "Done!"
echo "---------------------------------------------"

# Some user hints
echo "Run ${PREFIX}/bin/rvclang --target=ve-linux to compile for the VE"
echo "Run ${PREFIX}/bin/rvclang -march=native to compile for the VH"
