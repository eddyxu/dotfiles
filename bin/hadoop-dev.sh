#!/usr/local/bin/env zsh
#
# Hadoop development related functions

function mvn-package() {
	mvn package -Pdist -DskipTests
}

function hadoop-patch() {
	git diff --no-prefix trunk
}
