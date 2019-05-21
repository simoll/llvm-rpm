Scripts to create an RPM package of LLVM for VE with libraries
==============================================================

## Building RPM package from intalled LLVM

You are in llvm-rpm directory, and you have installed the llvm into `../local`,
and its version is 1.0.1, create SPECS/llvm-ve-1.0.1.spec and update
SPECS/llvm-ve-link.spec and then run

```
% ./mktar.sh ../local 1.0.1
% rpmbuild -bb SPECS/llvm-ve-1.0.1.spec --define "_topdir `pwd`"
% rpmbuild -bb SPECS/llvm-ve-link.spec --define "_topdir `pwd`"
```

Memo

- RPMファイルはErickさんのリポジトリに入れてもらう方針．ライセンス問題が解決したらやる
- バージョンの変え方（案）．一番左は適当に変える．真ん中は全世界に公開時に上げる．最後は社内向けに更新したとき．
- パッケージ名にバージョン番号を入れて複数入れられるようにする
- インストール先は/opt/nec/nosupport/llvm-ve-1.0.0


## Building RPM package from source

This repository contains Makefile and scripts to create an RPM package
of LLVM for NEC SX-Aurora VE with libraries.  Following libraries
are generated automatically.

- LLVM libc++
- LLVM libc++abi
- LLVM libunwind (VE uses SjLj exception only at the moment)
- LLVM openmp
- LLVM compiler-rt
- VE CSU

Prerequisites
=============

  - cmake (cmake3 on RHEL7)
  - ninja (ninja-build on RHEL7)
  - gcc 5.1 or above (devtoolset-8 on RHEL7)

Repository
==========

Clone repository by following command.

    $ git clone git@socsv218.svp.cl.nec.co.jp:ve-llvm/llvm-rpm.git

Create an RPM package
=====================

First, modify package version, branch/tag, and add changelog.

    $ vi Makefile
    $ vi llvm.spec

Then, create it.

    $ scl enable devtoolset-8 bash
    $ make
    $ ls RPMS/x86_64
    ...

Check the generated RPM package
===============================

Check description.

    $ rpm -qpi <generated rpm file>

Check changelog.

    $ rpm -qp --changelog <generated rpm file>

Check dependencies.

    $ rpm -qpR <generated rpm file>

