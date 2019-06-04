#!/bin/sh

# Use llvm-dev master branch by default
case x"$BRANCH" in
x) BRANCH=master;;
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
  git fetch origin $OPT

  # 2. Changed current branch to $BRANCH
  #    - This shows errors if local $BRANCH has conflicts
  git checkout $BRANCH

  # 3. Change current branch to $BRANCH if current branch is not dirty
  id=`git describe --always --abbrev=0 --match "NOT A TAG" --dirty="-dirty"`
  case $id in
  *-dirty)
    echo Modified source code is in `pwd`.
    echo Please commit or stash them.
    exit 1;;
  esac
  git reset --hard origin/$BRANCH
}

function clone_or_update() {
  repo=$1
  dir=$2

  if [ -d $dir ]; then
      cd $dir
      update
      make shallow-update BRANCH=$LLVM_BRANCH
  else
      git clone $repo -b $BRANCH $OPT $dir
      cd $dir
      make shallow BRANCH=$LLVM_BRANCH
  fi
}

# Update source codes under $DIR directory.
#REPO=git@socsv218.svp.cl.nec.co.jp:ve-llvm/llvm-dev.git
REPO=https://github.com/sx-aurora-dev/llvm-dev
clone_or_update $REPO $DIR
