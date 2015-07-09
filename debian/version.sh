#!/bin/bash

PPAVER=ppa9

LASTTAG=2.4
TAGCOMMIT=c28f1bab7822de97353849e7787b59e50bbb1428
echo ${LASTTAG}-n$(($(git log | grep commit | grep -B 9999 "${TAGCOMMIT}" | wc -l) - 1))-git$(git describe --always)-${PPAVER}

