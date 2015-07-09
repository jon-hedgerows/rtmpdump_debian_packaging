#!/bin/bash

GITREPO=git://git.ffmpeg.org/rtmpdump

mydir=$(dirname $(readlink -f $0))
parentdir=$(dirname $(readlink -f $mydir))

#get a clean and up to date version of the git repository
cd $parentdir
rm -rf rtmpdump.git
if [ -f rtmpdump.git.tar ]; then
  tar xf rtmpdump.git.tar
  cd rtmpdump.git
  git pull
  cd ..
  rm -f rtmpdump.git.tar
  tar cf rtmpdump.git.tar rtmpdump.git
else
  git clone $GITREPO rtmpdump.git
  tar cf rtmpdump.git.tar rtmpdump.git
fi
