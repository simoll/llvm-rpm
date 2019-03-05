THIS_MAKEFILE_PATH = $(abspath $(lastword $(MAKEFILE_LIST)))
BUILD_TOP_DIR = $(abspath $(dir ${THIS_MAKEFILE_PATH}))
INSTALL_PREFIX = ${BUILD_TOP_DIR}/install
VERSION_STRING = 0.9.3
LLVM_BRANCH = develop

all: source rpm

source: SOURCES/llvm-ve-${VERSION_STRING}.tar.gz

SOURCES/llvm-ve-${VERSION_STRING}.tar.gz:
	LLVM_BRANCH=${LLVM_BRANCH} DIR=llvm-ve-${VERSION_STRING} \
	    ./update-source.sh
	mkdir -p SOURCES
	tar -czf SOURCES/llvm-ve-${VERSION_STRING}.tar.gz \
	  llvm-ve-${VERSION_STRING}
	rm -rf llvm-ve-${VERSION_STRING}

rpm: RPMS/x86_64/llvm-ve-${VERSION_STRING}-1.el7.centos.x86_64.rpm

RPMS/x86_64/llvm-ve-${VERSION_STRING}-1.el7.centos.x86_64.rpm:
	rpmbuild -bb --define "_topdir ${BUILD_TOP_DIR}" \
	  --define "version ${VERSION_STRING}" \
	  --define "buildroot ${INSTALL_PREFIX}" \
	  ${BUILD_TOP_DIR}/llvm.spec

clean:
	rm -rf ${INSTALL_PREFIX}

.PHONY: all source update rpm clean FORCE
