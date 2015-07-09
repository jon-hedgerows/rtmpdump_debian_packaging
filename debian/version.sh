#!/bin/bash

debiandir=$(dirname $(readlink -f $0))

cd $debiandir/..
git describe --tags --match v* | cut -c2-
