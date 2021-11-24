# LLVM-RPM

Utility scripts to build RPMs for llvm-ve-rv.

### Instructions

To build a new RPM with a given version (`VERSION_STRING`), git repository prefix (`REPOS`) and `BRANCH`, run the following:

`make VERSION_STRING=<version_suffix> REPOS=<REPOS> BRANCH=<llvm-dev-ALSO-llvm-project-branch`


### Example

The following command compiles the RPM for the llvm-ve-rv 2.0 release.

`make VERSION_STRING=2.0.0 REPOS=https://github.com/sx-aurora-dev BRANCH=hpce/release_2.0`


## Build prerequesites

The build internally uses the llvm-dev scripts to build the full llvm-ve stack.
Required packages are listed at `https://github.com/sx-aurora-dev/llvm-dev`.

You will also need a fairly new version of `tar` that supports the `--exclude-vcs`
flag. The version in CentOS 7 is too old.
