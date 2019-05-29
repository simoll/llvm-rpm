# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing
%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Summary: LLVM for VectorEngine of SX-Aurora TSUBASA 
Name: llvm-ve-1.1.1
Version: 1.1.1
Release: 1
License: GPL+
Group: Development/Tools
SOURCE0 : %{name}-%{version}.tar
URL: https://github.com/SXAuroraTSUBASAResearch/llvm

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
%{summary}

%prep
%setup -q

%build
# Empty section.

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}

# in builddir
cp -a * %{buildroot}

%clean
rm -rf %{buildroot}


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

