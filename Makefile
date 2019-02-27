THIS_MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
BUILD_TOP_DIR := $(abspath $(dir ${THIS_MAKEFILE_PATH}))
INSTALL_PREFIX := ${BUILD_TOP_DIR}/install
VERSION_STRING := 0.9.1
BRANCH := master

all: source rpm

source: SOURCES/llvm-ve-${VERSION_STRING}.tar.gz

SOURCES/llvm-ve-${VERSION_STRING}.tar.gz:
	BRANCH=gitea DIR=llvm-ve-${VERSION_STRING} ./update-source.sh
	mkdir -p SOURCES
	tar -czf SOURCES/llvm-ve-${VERSION_STRING}.tar.gz \
	  llvm-ve-${VERSION_STRING}

# Force to update source code
update: FORCE
	BRANCH=gitea DIR=llvm-ve-${VERSION_STRING} ./update-source.sh
	mkdir -p SOURCES
	tar -czf SOURCES/llvm-ve-${VERSION_STRING}.tar.gz \
	  llvm-ve-${VERSION_STRING}

rpm:
	rpmbuild -bb --define "_topdir ${BUILD_TOP_DIR}" \
	  --define "version ${VERSION_STRING}" \
	  --define "buildroot ${INSTALL_PREFIX}" \
	  ${BUILD_TOP_DIR}/llvm.spec

clean:
	rm -rf ${INSTALL_PREFIX}

.PHONY: all source update rpm clean FORCE
