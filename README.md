Scripts to create an RPM package of LLVM for VE with libraries
==============================================================

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
  - gcc 5.1 or above (devtoolset-4 on RHEL7)

Repository
==========

Clone repository by following command.

    $ git clone git@socsv218.svp.cl.nec.co.jp:ve-llvm/llvm-rpm.git

Create an RPM package
=====================

First, modify package version and add changelog.

    $ vi Makefile
    $ vi llvm.spec

Then, create it.

    $ scl enable devtoolset-4 bash
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
