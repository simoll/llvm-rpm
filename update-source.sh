#!/bin/sh

# Use llvm-dev master branch by default
case x"${LLVM_DEV_BRANCH}" in
x) echo "Define LLVM_DEV_BRANCH"
   exit 1;;
*) ;;
esac

# Use llvm develop branch by default
case x"$LLVM_BRANCH" in
x) LLVM_BRANCH=develop;;
*) ;;
esac

# Check target $DIR
case x"$DIR" in
x) echo Please specify target directory to extract source code by
   echo DIR environment variable.
   exit 1;;
*) ;;
esac

OPT="$@"

# Use shallow clone to fetch source code
OPT="--depth 1 $OPT"

# Need -f option (force) for the case of shallow clone
FOPT=""
case "$OPT" in
*"--depth 1"*) FOPT="-f";;
*) ;;
esac

function update() {
  # 1. Fetch target $BRANCH
  git fetch origin ${OPT}

  # 2. Changed current branch to $BRANCH
  #    - This shows errors if local $BRANCH has conflicts
  git checkout ${BRANCH}

  # 3. Change current branch to $BRANCH if current branch is not dirty
  id=`git describe --always --abbrev=0 --match "NOT A TAG" --dirty="-dirty"`
  case $id in
  *-dirty)
    echo Modified source code is in `pwd`.
    echo Please commit or stash them.
    exit 1;;
  esac
  git reset --hard origin/${LLVM_DEV_BRANCH}
}

function clone_or_update() {
  repo=$1
  dir=$2

  if [ -d $dir ]; then
      cd $dir
      update
      make update REPOS=${REPOS} BRANCH=${LLVM_BRANCH} BUILD_TYPE=Release
  else
      git clone $repo -b ${LLVM_DEV_BRANCH} ${OPT} $dir
      cd $dir
      make clone REPOS=${REPOS} BRANCH=${LLVM_BRANCH} BUILD_TYPE=Release
  fi
}

clone_or_update ${DEVREPO} ${DIR}
