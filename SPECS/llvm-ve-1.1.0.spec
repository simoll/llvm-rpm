Summary:        LLVM for VectorEngine of SX-Aurora TSUBASA 
Name:		%{name}
Version:	%{version}
Release:	%{release}

Group:		Development/Libraries
License:	Apache License v2.0 with LLVM Exceptions
URL:		https://github.com/SXAuroraTSUBASAResearch/llvm
Source0:	%{name}-%{version}.tar
Prefix:         /opt/nec/nosupport/%{name}

# Building llvm requires gcc-5.1 or above, but it is sometime provided
# as devtoolset-X, so we simply says gcc-c++ here.
BuildRequires:	binutils gcc-c++ cmake3 ninja-build

# Llvm for VE requires binutils, glibc, and header files for VE.
Requires:	binutils-ve glibc-ve glibc-ve-devel kernel-headers-ve
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
# make %{?_smp_mflags} DEST=%{buildroot}/opt/nec/nosupport/llvm-%{version}
make DEST=%{buildroot}/opt/nec/nosupport/%{name}

%install
make DEST=%{buildroot}/opt/nec/nosupport/%{name} installall

%files
%defattr(-,root,root,-)
%dir /opt/nec/nosupport/%{name}
%dir /opt/nec/nosupport/%{name}/bin
%dir /opt/nec/nosupport/%{name}/include
%dir /opt/nec/nosupport/%{name}/lib
%dir /opt/nec/nosupport/%{name}/libexec
%dir /opt/nec/nosupport/%{name}/share
/opt/nec/nosupport/%{name}/bin/*
/opt/nec/nosupport/%{name}/include/*
/opt/nec/nosupport/%{name}/lib/*
/opt/nec/nosupport/%{name}/libexec/*
/opt/nec/nosupport/%{name}/share/*

%changelog
