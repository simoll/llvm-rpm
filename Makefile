THIS_MAKEFILE_PATH = $(abspath $(lastword $(MAKEFILE_LIST)))
BUILD_TOP_DIR = $(abspath $(dir ${THIS_MAKEFILE_PATH}))

VERSION_STRING	?= $(error "Define VERSION_STRING")
NAME		= llvm-ve-rv-${VERSION_STRING}
RELEASE_STRING 	= 1
DIST_STRING = .el7.centos
SOTOC_DEFAULT_COMPILER = ncc
INSTALL_DIR=../local
BUILD_TYPE = Release

DIR=${NAME}-${VERSION_STRING}

# RPM Paths.
SOURCES_DIR=${BUILD_TOP_DIR}/SOURCES
BUILD_DIR=${BUILD_TOP_DIR}/BUILD

# Derived Paths.
SOURCE_NAME=${NAME}-${VERSION_STRING}
SOURCE_TAR=SOURCES/${SOURCE_NAME}.tar

SOURCE_MONOREPO=${SOURCES_DIR}/${SOURCE_NAME}/llvm-project
BUILD_MONOREPO=${BUILD_DIR}/${SOURCE_NAME}/llvm-project

# Repos.
REPOS=$(error "Define REPOS")
DEV_REPO=${REPOS}/llvm-dev.git
LLVM_REPO=${REPOS}/llvm-project.git

# Source branches.
BRANCH ?= $(error "Define BRANCH or LLVM_BRANCH and DEV_BRANCH")
LLVM_BRANCH ?= ${BRANCH}
DEV_BRANCH ?= ${BRANCH}

all: source rpm

source: ${SOURCE_TAR}

${SOURCE_TAR}:
	mkdir -p ${SOURCES_DIR}/${SOURCE_NAME}
	-git clone ${DEV_REPO} -b ${DEV_BRANCH} ${SOURCES_DIR}/${SOURCE_NAME}/llvm-dev
	-make -f ${SOURCES_DIR}/${SOURCE_NAME}/llvm-dev/Makefile clone BRANCH=${LLVM_BRANCH} REPOS=${REPOS} LLVM_BUILD_TYPE=${BUILD_TYPE} MONOREPO=${SOURCE_MONOREPO}
	tar --exclude-vcs --exclude-vcs-ignores -C ${SOURCES_DIR} -cf $@ ${SOURCE_NAME}
	rm -rf ${SOURCES_DIR}/${SOURCE_NAME}

rpm:
	rpmbuild -ba --define "_topdir ${BUILD_TOP_DIR}" \
	  --define "name ${NAME}" \
	  --define "build_type ${BUILD_TYPE}" \
	  --define "version ${VERSION_STRING}" \
	  --define "release ${RELEASE_STRING}" \
	  --define "dist ${DIST_STRING}" \
	  --define "monorepo_dir ${BUILD_MONOREPO}" \
	  --define "build_dir ${BUILD_DIR}" \
	  --define "sotoc_default ${SOTOC_DEFAULT_COMPILER}" \
	  ${BUILD_TOP_DIR}/SPECS/llvm-ve-rv-rolling.spec

clean:
	rm -rf ${BUILD_DIR}
	rm -rf ${SOURCES_DIR}
	rm -rf RPMS

.PHONY: rpm source
