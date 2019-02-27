#!/bin/sh

# Use github branch by default
case x"$BRANCH" in
x) BRANCH=github;;
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
  # 2. Changed local $BRANCH to specify remote $BRANCH
  #    - Add -u option (update-head-ok) to update current branch
  #    - This shows errors if local $BRANCH is not ok to fast-forward rebase
  git fetch origin $OPT && \
    git fetch origin $BRANCH:$BRANCH $OPT $FOPT -u

  # 3. Change current branch to $BRANCH if current branch is not dirty
  id=`git describe --always --abbrev=0 --match "NOT A TAG" --dirty="-dirty"`
  case $id in
  *-dirty)
    echo Modified source code is in `pwd`.
    echo Please commit or stash them.
    exit 1;;
  esac
  git checkout $BRANCH
  git reset --hard origin/$BRANCH
}

function clone_or_update() {
  repo=$1
  dir=$2

  if [ -d $dir ]; then
      cd $dir
      update
      make shallow-update
  else
      git clone $repo -b $BRANCH $OPT $dir
      cd $dir
      make shallow
  fi
}

# Update source codes under $DIR directory.
REPO=git@socsv218.svp.cl.nec.co.jp:ve-llvm/llvm-dev.git
clone_or_update $REPO $DIR
