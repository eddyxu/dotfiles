#!/bin/sh
# Setting up vim on a new machine

ROOTDIR=`dirname $0`
if [ ! -d ~/.vim/bundle ]; then
	mkdir -p ~/.vim/{autoload,bundle}
fi
for d in `find $ROOTDIR -maxdepth 1 -type d`; do
  echo cp -rf $d ~/.vim
done
cd ~/.vim

curl -so ~/.vim/autoload/pathogen.vim \
	    https://raw.github.com/tpope/vim-pathogen/HEAD/autoload/pathogen.vim

git init
git submodule add https://github.com/mitechie/pyflakes-pathogen.git bundle/pyflakes
git submodule add https://github.com/reinh/vim-makegreen bundle/makegreen
git submodule add https://github.com/sontek/rope-vim.git bundle/ropevim
git submodule add https://github.com/vim-scripts/The-NERD-tree.git bundle/nerdtree
git submodule add https://github.com/vim-scripts/pep8.git bundle/pep8
git submodule add git://github.com/vim-scripts/taglist.vim.git bundle/taglist
git submodule add git://github.com/vim-scripts/Pydiction.git bundle/pydiction
git submodule add git://github.com/vim-scripts/cscope_macros.vim.git bundle/cscope
git submodule init
git submodule update
git submodule foreach git submodule init
git submodule foreach git submodule update

BASEDIR=`dirname $0`
cd `dirname $0`

# make tags for C++
ctags -f ~/.vim/tags -R /usr/include /usr/local/include

# make tags for python
if [ ! -d ftplugin ]; then
  mkdir -p ftplugin
fi
cd ftplugin
python ../bundle/pydiction/pydiction.py os sys re subprocess argparse \
		   itertools functools \
		   numpy scipy matplotlib

echo "**********************************************"
echo "Please add the following line to your ~/.vimrc"
echo "   source $ROOTDIR/vim/_vimrc"
