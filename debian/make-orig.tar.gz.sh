#!/bin/bash
#
# either get an existing rtmpdump_<version>.orig.tar.gz, or make one

# existing .orig.tar.gz files at 
#  https://launchpad.net/~jon-hedgerows/+archive/rtmpdump/+files/rtmpdump_<version>.orig.tar.gz
# are considered canonical and hence reused

force=$1
debiandir=$(dirname $(readlink -f $0))
packagedir=$(basename $(readlink -f $debiandir/..))
outputdir=$(readlink -f $debiandir/../..)

version=$($debiandir/version.sh)

cd $outputdir
tarball=rtmpdump_${version}.orig.tar.gz

if [ -e $tarball ] ; then
  if [ "$force" = "-f" ]; then
    rm -rf $tarball
  else
    echo $tarball already exists
    echo not updated.  use $0 -f to force update
    exit 0
  fi
fi

# first try to get tarball from launchpad
if curl https://launchpad.net/~jon-hedgerows/+archive/rtmpdump/+files/$tarball --location -o $tarball --fail -s ; then
  # ok - fetched from get-iplayer
  echo Fetched $tarball from ppa:jon-hedgerows/rtmpdump
  exit 0
else
  # create a new one
  echo Creating new $tarball
  tar czvf $tarball $packagedir --exclude=debian --exclude=.git
fi

