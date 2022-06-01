#!/bin/sh

basedir=$(realpath "$(dirname "$0")/..")

name=${name:-echotcp}
summary=${summary:-"TCP echo service"}
description=${description:-$basedir/rpm/description}
www=${www:-"https://github.com/sg2342/echotcp"}
license=${license:-APACHE20}
vm_args=${vm_args:-$basedir/rpm/vm.args}
sys_config=${sys_config:-$basedir/rpm/sys.config}
override=${override:-$basedir/rpm/override.config}
firewalld=${firewalld:-$basedir/rpm/firewalld}

. $basedir/rpm/common/create
