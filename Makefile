THIS_MAKEFILE_PATH = $(abspath $(lastword $(MAKEFILE_LIST)))
BUILD_TOP_DIR = $(abspath $(dir ${THIS_MAKEFILE_PATH}))

INSTALL_PREFIX = ${BUILD_TOP_DIR}/install
NAME		= llvm-ve-1.1.0
VERSION_STRING	= 1.1.0
RELEASE_STRING 	= 1
DIST_STRING = .el7.centos
LLVM_BRANCH = develop
LLVM_DEV_BRANCH = develop
TAR=SOURCES/${NAME}-${VERSION_STRING}.tar

DIR=${NAME}-${VERSION_STRING}

all: source rpm

source: ${TAR}

${TAR}:
	LLVM_BRANCH=${LLVM_BRANCH} BRANCH=${LLVM_DEV_BRANCH} \
	    DIR=${DIR} ./update-source.sh
	mkdir -p SOURCES
	tar --exclude .git -cf $@ ${DIR}
	rm -rf ${DIR}

rpm:
	rpmbuild -ba --define "_topdir ${BUILD_TOP_DIR}" \
	  --define "name ${NAME}" \
	  --define "version ${VERSION_STRING}" \
	  --define "release ${RELEASE_STRING}" \
	  --define "dist ${DIST_STRING}" \
	  --define "buildroot ${INSTALL_PREFIX}" \
	  ${BUILD_TOP_DIR}/SPECS/${NAME}.spec

clean:
	rm -rf ${INSTALL_PREFIX}

.PHONY: all source update rpm clean FORCE
