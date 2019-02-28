Name:		llvm-ve
Version:	%{version}
Release:	1%{?dist}
Summary:	The Low Level Virtual Machine (LLVM) for NEC SX-Aurora VE

Group:		Development/Libraries
License:	NCSA
URL:		https://github.com/SXAuroraTSUBASAResearch/llvm
Source0:	llvm-ve-%{version}.tar.gz
Prefix:         /opt/nec/nosupport/llvm-%{version}

# Building llvm requires gcc-5.1 or above, but it is sometime provided
# as devtoolset-X, so we simply says gcc-c++ here.
BuildRequires:	binutils gcc-c++ cmake3 ninja-build

# Llvm for VE requires binutils, glibc, and header files for VE.
Requires:	binutils-ve glibc-ve glibc-ve-devel kernel-headers-ve
# Llvm for VE also requires shared libraries on host
Requires:       libgcc glibc libstdc++

# Force to not compress binary files since it modifies object files
# and converts elf header from VE to x86.
%global __os_install_post %{nil}

# FIXME: we need to support stripping and debug information for VE
%define debug_package %{nil}

%description
LLVM for NEC SX-Aurora VE
=========================

This repository is a clone of public LLVM repository (http://llvm.org), plus an
experimental modifications which provides support for the NEC SX-Aurora Tsubasa
Vector Engine (VE).

Modifications are under the development.  We know following flaws.

 - automatic vectorization is not supported yet

Please file issues if you have problems.

Prerequisites
=============

Following packages are required.
Those are available from https://sx-aurora.com/repos/veos/common/x86_64/.

 - binutils-ve
 - glibc-ve
 - glibc-ve-devel
 - kernel-headers-ve

Includes
========

 - clang (C compiler)
 - clang++ (C++ compiler)
 - compier-rt library (runtime library)
 - ve-csu library (crtbeing.o/crtend.o from NetBSD CSU)
 - libc++ library (for C++)
 - libc++abi library (for libc++)
 - libcunwind library (for libc++abi)
 - openmp library (OpenMP)
%prep
%setup -q

%build
# Multi-process build is not supported yet.
# Internal makefile performs "ninja -j8" (appropriate to our build machine).
# Please modify it to increase processes.
# make %{?_smp_mflags} DEST=%{buildroot}/opt/nec/nosupport/llvm-%{version}
make DEST=%{buildroot}/opt/nec/nosupport/llvm-%{version}

%install
make DEST=%{buildroot}/opt/nec/nosupport/llvm-%{version} installall

%files
%doc
%defattr(-,root,root,-)
/opt/nec/nosupport/llvm-%{version}/bin/*
/opt/nec/nosupport/llvm-%{version}/include/*
/opt/nec/nosupport/llvm-%{version}/lib/*
/opt/nec/nosupport/llvm-%{version}/libexec/*
/opt/nec/nosupport/llvm-%{version}/share/*

%changelog
* Wed Feb 28 2019 Kazushi (Jam) Marukawa <kaz-marukawa@xr.jp.nec.com> - 0.9.3-1
- Update package information

* Wed Feb 27 2019 Kazushi (Jam) Marukawa <kaz-marukawa@xr.jp.nec.com> - 0.9.2-1
- Change to use devtoolset-4 instead of devtoolset-8 since latter cause
  unrecognized relocation (0x2a) with RHEL/CentOS7 default ld (2.25)

* Wed Feb 27 2019 Kazushi (Jam) Marukawa <kaz-marukawa@xr.jp.nec.com> - 0.9.1-1
- Initial release
