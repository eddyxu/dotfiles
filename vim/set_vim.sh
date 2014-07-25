#!/bin/sh
# Setting up vim on a new machine

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

if [ -d ~/.vim/bundle/vundle ]; then
	rm -rf ~/.vim/bundle/vundle
fi
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

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

# Set YouCompleteMe
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer
