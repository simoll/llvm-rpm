THIS_MAKEFILE_PATH = $(abspath $(lastword $(MAKEFILE_LIST)))
BUILD_TOP_DIR = $(abspath $(dir ${THIS_MAKEFILE_PATH}))

INSTALL_PREFIX = ${BUILD_TOP_DIR}/install
VERSION_STRING	= 1.3.0
NAME		= llvm-ve-rv-${VERSION_STRING}
RELEASE_STRING 	= 1
DIST_STRING = .el7.centos
LLVM_BRANCH = hpce/develop
LLVM_DEV_BRANCH = hpce/develop
TAR=SOURCES/${NAME}-${VERSION_STRING}.tar
INSTALL_DIR=../local

DIR=${NAME}-${VERSION_STRING}

# Update source codes under $DIR directory.
#REPO=git@socsv218.svp.cl.nec.co.jp:ve-llvm/llvm-dev.git
REPOS=~/repos
DEVREPO=${REPOS}/llvm-dev.git
# DEVREPO=git@socsv218.svp.cl.nec.co.jp:ve-llvm/llvm-dev.git

all: source rpm

source: ${TAR}

${TAR}:
	LLVM_BRANCH=${LLVM_BRANCH} BRANCH=${LLVM_DEV_BRANCH} \
	    DIR=${DIR} DEVREPO=${DEVREPO} ./update-source.sh
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
	  --define "repos" ${REPOS} \
	  ${BUILD_TOP_DIR}/SPECS/${NAME}.spec

local-rpm:
	./mktar.sh ${INSTALL_DIR} ${VERSION_STRING}
	rpmbuild -bb SPECS/llvm-ve-local.spec \
		--define "_topdir `pwd`" \
		--define "name ${NAME}" \
		--define "version ${VERSION_STRING}" \
		--define "release ${RELEASE_STRING}"
	rpmbuild -bb SPECS/llvm-ve-link.spec \
		--define "_topdir `pwd`" \
		--define "version ${VERSION_STRING}" \
		--define "release ${RELEASE_STRING}"


clean:
	rm -rf ${INSTALL_PREFIX}

.PHONY: all source update rpm clean FORCE
