#!/usr/bin/env bash
#
# Install dotfiles to home directory.
# Author: Lei Xu <eddyxu@gmail.com>

function link_file {
    source="${PWD}/$1"
    target="${HOME}/${1/_/.}"

    if [ -e "${target}" ]; then
        mv $target $target.bak
    fi

    ln -sf ${source} ${target}
}

# Let the home file to source the this configure.
# Works for bash/vim
function source_file {
	srcfile="${PWD}/$1"
	target="${HOME}/${1/_/.}"
	if [ ! -e ${target} ] || grep ${srcfile} $target 2>/dev/null; then
		echo "source ${srcfile}" >> $target
	fi
}

curl -L http://install.ohmyz.sh | sh

for i in _*; do
	if [ $i == '_bashrc' ]; then
		source_file $i
		continue
	fi
	link_file $i
done
