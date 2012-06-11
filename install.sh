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

for i in _*; do
	link_file $i
done
