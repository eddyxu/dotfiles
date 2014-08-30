#!/usr/bin/env bash
#
# Build Clang based devtools

DEVTOOL_ROOT=~/tmp/devtool

function checkout() {
  cd $DEVTOOL_ROOT
  svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm

  cd llvm/tools
  svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
  cd ../..

  cd llvm/tools/clang/tools
  svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
  cd ../../../..

  cd llvm/projects
  svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
  svn co http://llvm.org/svn/llvm-project/libcxxabi/trunk libcxxabi
  svn co http://llvm.org/svn/llvm-project/libcxx/trunk libcxx
  cd ../..
}

function build_clang() {
  cd $DEVTOOL_ROOT/llvm
  mkdir build && cd build
  CC=clang CXX=clang++ cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON ..
  make -j8
}

if [[ ! -d $DEVTOOL_ROOT ]]; then
  mkdir -p $DEVTOOL_ROOT
fi

checkout
build_clang
