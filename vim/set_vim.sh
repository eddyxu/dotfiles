#!/bin/sh
# Setting up vim on a new machine


curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

ROOTDIR=`dirname $0`
cd $ROOTDIR/..
ROOTDIR=`pwd`
if [ ! -d ~/.vim/bundle ]; then
  mkdir -p ~/.vim/bundle
fi
if [ ! -d ~/.vim/autoload ]; then
  mkdir -p ~/.vim/autoload
fi
for d in `find $ROOTDIR/vim -maxdepth 1 -type d`; do
  cp -rf $d ~/.vim
done

if [ -d ~/.vim/bundle/Vundle.vim ]; then
  rm -rf ~/.vim/bundle/Vundle.vim
fi
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

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

vim +BundleInstall +qall

#cd ~/.vim/bundle/clang_complete
#make
