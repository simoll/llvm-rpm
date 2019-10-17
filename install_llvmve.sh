#!/usr/bin/env bash

WGET="wget --connect-timeout=5"
RPM_CPIO=rpm2cpio
CPIO=cpio

LLVM_VE_VERSION=1.7.0
RELEASE_TAG=github_release_20191010

RELEASE_BASE_URL=https://github.com/sx-aurora-dev/llvm-project/releases/download/
RELEASE_SUFFIX=${RELEASE_TAG}/llvm-ve-${LLVM_VE_VERSION}-${LLVM_VE_VERSION}-1.x86_64.rpm
RELEASE_URL=${RELEASE_BASE_URL}/${RELEASE_SUFFIX}

RPM_FILE="llvm-ve-${LLVM_VE_VERSION}-${LLVM_VE_VERSION}-1.x86_64.rpm"
RPM_PATH="${PWD}/${RPM_FILE}"
RPM_INTERNAL_PREFIX="opt/nec/nosupport/llvm-ve-${LLVM_VE_VERSION}"


# Info
echo "---------------------------------------------"
echo "     Installer for local LLVM-VE ${LLVM_VE_VERSION}"
echo "---------------------------------------------"

# Download
if ! rpm -K --nosignature ${RPM_FILE} | grep -q OK -; then
  echo "Downloading release ${RELEASE_SUFFIX} to ${RPM_FILE}"
  ${WGET} -o ${RPM_PATH} ${RELEASE_URL}
else
  echo "Using archive ${RPM_PATH}"
fi

# Verify integrity
if ! rpm -K --nosignature ${RPM_FILE} | grep -q OK -; then
  echo "Corrupted archive (${RPM_FILE})!"
  exit 1;
fi

echo "Verified RPM checksum!"

# Read install prefix
DEFAULT_PREFIX="${PWD}/install"
read -i ${DEFAULT_PREFIX} -p "Install prefix (Leave empty for ${DEFAULT_PREFIX}): " PREFIX
PREFIX=${PREFIX:-${DEFAULT_PREFIX}}


# Unpack
echo "Installing to ${PREFIX}"
mkdir -p ${PREFIX}
CWD=${PWD}
cd ${PREFIX} && ${RPM_CPIO} ${RPM_PATH} | ${CPIO} -duim --quiet
cd ${PREFIX} && mv ${RPM_INTERNAL_PREFIX}/* .
cd ${CWD}

echo "Done!"
echo "---------------------------------------------"

# Some user hints
echo "Run ${PREFIX}/bin/clang --target=ve-linux to compile for the VE"
echo "Run ${PREFIX}/bin/clang -march=native to compile for the VH"
