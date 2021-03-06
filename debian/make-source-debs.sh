#!/bin/bash

mydir=$(dirname $(readlink -f $0))
parentdir=$(dirname $(readlink -f $mydir))

$mydir/make-get-git-repo.sh

# get a clean version of the git repository
cd $parentdir
rm -rf rtmpdump.git
tar xf rtmpdump.git.tar

# copy the debian directory into place and adjust
cp -R $mydir $parentdir/rtmpdump.git
cd $mydir
# get a version number for this release
cat versionppa.sh | sed s/verppa=.*$/verppa=$(git describe --tags | sed 's/-/x/g')/ > $parentdir/rtmpdump.git/debian/versionppa.sh
# record the actual git log
#cd $parentdir/rtmpdump.git
#git log > $parentdir/rtmpdump.git/debian/README.git-log

# make an orig.tar.gz
$parentdir/rtmpdump.git/debian/make-orig.tar.gz.sh

# build source debs for each release
for dist in trusty xenial yakkety zesty artful; do
  cd $parentdir/rtmpdump.git
  # only the debian changelog changes per dist, update it
  #cp $mydir/changelog debian/changelog
  #dch -v $($parentdir/rtmpdump.git/debian/versionppa.sh)~$dist -D $dist "New upstream snapshot, see README.git-log"
  cp $mydir/changelog debian/changelog
  LASTTAGSHORT=$(head -1 debian/changelog  | sed 's/^.*git\(.......\)-.*$/\1/g')
  LASTTAG=$(git rev-parse $LASTTAGSHORT)
  dch -b -v $($parentdir/rtmpdump.git/debian/versionppa.sh)~$dist -D $dist "New upstream snapshot"
  # and add the short git logs
  git log $LASTTAG.. --pretty=format:"%h: %s [%an]" | while read -r ll ; do dch -a "$ll" ; done

  # and build the source packages
  if [ -z $DEBSIGN_KEYID ]; then
    debuild -S
  else
    debuild -S -k$DEBSIGN_KEYID
  fi
done

