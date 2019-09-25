#!/usr/bin/bash

perl Makefile.PL
make manifest
make dist
dh-make-perl --vcs no --email partizand@gmail.com --build
# dh-make-perl --vcs no --email partizand@gmail.com --build-source
