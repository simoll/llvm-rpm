#! /bin/sh

dir=$1
shift

ver=$1
shift

if test x$dir = x -o x$ver = x; then
        echo "Usage: $0 <install directory> <version>"
        exit
fi


path=$(readlink -f $dir)
dir=$(basename $path)
cur=$(pwd)

echo $path
echo $dir
echo $ver

(cd ${path}/..  && tar cf ${cur}/SOURCES/llvm-ve-${ver}-${ver}.tar --xform="s%${dir}%llvm-ve-${ver}-${ver}/opt/nec/nosupport/llvm-ve-${ver}%" ${dir})
