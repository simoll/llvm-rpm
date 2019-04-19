# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing
%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Summary: LLVM for VectorEngine of SX-Aurora TSUBASA 
Name: llvm-ve-1.0.1
Version: 1.0.1
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
ln -s /opt/nec/nosupport/%{name} %{buildroot}/opt/nec/nosupport/llvm-ve

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
/opt/*

%changelog
