Summary:        LLVM for VectorEngine of SX-Aurora TSUBASA 
Name:		%{name}
Version:	%{version}
Release:	%{release}

Group:		Development/Libraries
License:	Apache License v2.0 with LLVM Exceptions
URL:		https://github.com/sx-aurora-dev/llvm-project
Source0:	%{name}-%{version}.tar
Prefix:         /usr/local/ve/%{name}

# Building llvm requires gcc-5.1 or above, but it is sometime provided
# as devtoolset-X, so we simply says gcc-c++ here.
# BuildRequires:	binutils gcc-c++ cmake3 ninja-build

# Llvm for VE requires binutils, glibc, and header files for VE.
Requires:	binutils-ve glibc-ve glibc-ve-devel kheaders-ve
# Llvm for VE also requires shared libraries on host
Requires:       libgcc glibc libstdc++

# We use name with version information to not to be removed old version
# by yum, but this package is a llvm-ve package, so define it here.
#Provides:       llvm-ve = %{version}-%{release}

# Force to not compress binary files since it modifies object files
# and converts elf header from VE to x86.
%global __os_install_post %{nil}

# FIXME: we need to support stripping and debug information for VE
# Temporary disable generating debug package since host's rpmbuild
# doesn't support rpm packaging for VE.  It shows errors on VE
# binaries.
%define debug_package %{nil}

%description
%{summary}

%prep
%setup -q -n %{name}-%{version}

%build
# Multi-process build is not supported yet.
# Internal makefile performs "ninja -j8" (appropriate to our build machine).
# Please modify it to increase processes.
# make %{?_smp_mflags} DEST=%{buildroot}/opt/nec/ve/LLVM/llvm-ve-rv-%{version}

# /usr/local/ve --> BUILDROOT/usr/local/ve
# mkdir -p /usr/local/ve
# mkdir -p %{buildroot}/usr/local
# ln -s /usr/local/ve %{buildroot}/usr/local/ve

make -f llvm-dev/ve-linux-steps.make BUILDROOT=%{build_dir} MONOREPO=%{monorepo_dir} BUILD_TYPE=%{build_type} PREFIX=%{prefix} SOTOC_DEFAULT_COMPILER=%{sotoc_default} LLVM_BUILD_DYLIB=On LLVM_BUILD_SOLIBS=Off LLVM_BUILD_TYPE=Release build-llvm

%install
make -f llvm-dev/ve-linux-steps.make BUILDROOT=%{build_dir} MONOREPO=%{monorepo_dir} BUILD_TYPE=%{build_type} PREFIX=%{prefix} SOTOC_DEFAULT_COMPILER=%{sotoc_default} LLVM_BUILD_DYLIB=On LLVM_BUILD_SOLIBS=Off LLVM_BUILD_TYPE=Release install

# Migrate to BUILDROOT to pass validation.
mkdir -p %{buildroot}/usr/local/ve
mv %{prefix} %{buildroot}/usr/local/ve/

%files
%defattr(-,root,root,-)
%dir %{prefix}
%dir %{prefix}/bin
%dir %{prefix}/include
%dir %{prefix}/lib
%dir %{prefix}/libexec
%dir %{prefix}/share
%{prefix}/bin/*
%{prefix}/include/*
%{prefix}/lib/*
%{prefix}/libexec/*
%{prefix}/share/*

%changelog
