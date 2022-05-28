#!/bin/sh

basedir=$(realpath "$(dirname "$0")/..")

name=${name:-echotcp}
comment=${comment:-"TCP echo service"}
description=${description:-"A simple TCP echo service\nimplemented with the new erlang socket API"}
www=${www:-"https://github.com/sg2342/echotcp"}
uid=${uid:-7777}
gid=${gid:-7777}
license=${license:-APACHE20}
maintainer=${maintainer:-"not maintained at all"}
vm_args=${vm_args:-$basedir/pkg/vm.args}
sys_config=${sys_config:-$basedir/pkg/sys.config}
override=${override:-$basedir/pkg/override.config}

. $basedir/pkg/common/create
