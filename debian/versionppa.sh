#!/bin/bash

debiandir=$(dirname $(readlink -f $0))

verppa=ppa1

echo $($debiandir/version.sh)-$verppa
