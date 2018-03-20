#!/bin/sh
# Setting up vim on a new machine

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ROOTDIR=`dirname $0`
cd $ROOTDIR/..
ROOTDIR=`pwd`
BASEDIR=`dirname $0`
cd `dirname $0`

VIMRC="$ROOTDIR/vim/_vimrc"
if [ ! -f ~/.vimrc ]; then
  echo "source $VIMRC" >> ~/.vimrc
fi

if ! grep "source $VIMRC" ~/.vimrc >/dev/null; then
  echo "Back up ~/.vimrc to ~/.vimrc.bak "
  cp ~/.vimrc ~/.vimrc.bak
  echo "source $VIMRC" >> ~/.vimrc
fi
