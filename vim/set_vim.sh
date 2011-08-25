#!/bin/sh

BASEDIR=`dirname $0`
cd `dirname $0`
echo $PWD
if ! grep -E 'source .+/vimrc' ~/.vimrc > /dev/null; then
	echo "source $PWD/vimrc" >> ~/.vimrc
fi

cd ~/.vim
# make tags for C++
ctags -f tags -R /usr/include /usr/local/include

# make tags for python
cd ftplugin
python pydiction.py os sys re subprocess optparse \
		   itertools functools \
		   numpy scipy matplotlib
