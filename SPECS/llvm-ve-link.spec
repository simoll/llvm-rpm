# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing
%define        __spec_install_post %{nil}
%define          debug_package %{nil}
%define        __os_install_post %{_dbpath}/brp-compress

Summary: LLVM for VectorEngine of SX-Aurora TSUBASA 
Name: llvm-ve-link
Version: 1.1.0
Release: 1
License: GPL+
Group: Development/Tools
URL: https://github.com/SXAuroraTSUBASAResearch/llvm

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
%{summary}

%prep
#%setup -q

%build
# Empty section.

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}/opt/nec/nosupport
ln -s /opt/nec/nosupport/llvm-ve-%{version} %{buildroot}/opt/nec/nosupport/llvm-ve

%clean
#rm -rf %{buildroot}


%files
%defattr(-,root,root,-)
/opt/nec/nosupport/llvm-ve

%changelog

