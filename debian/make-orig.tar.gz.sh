#!/bin/bash

force=$1
debiandir=$(dirname $(readlink -f $0))
packagedir=$(basename $(readlink -f $debiandir/..))
outputdir=$(readlink -f $debiandir/../..)

version=$(head -1 $debiandir/changelog  | cut -f2 -d\( | cut -f1 -d\) | sed "s/-ppa[0-9]*//")
package=$(head -1 $debiandir/changelog  | cut -f1 -d\ )

pushd $outputdir > /dev/null
tarball=${package}_${version}.orig.tar.gz

if [ -e $tarball ] ; then
  if [ "$force" = "-f" ]; then
    rm -rf $tarball
  else
    echo $tarball already exists
    echo not updated.  use $0 -f to force update
  fi
fi
test -e $tarball || tar czvf $tarball $packagedir --exclude=debian --exclude=.git
popd > /dev/null

