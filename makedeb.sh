#!/usr/bin/bash

perl Makefile.PL
make manifest
make
make dist

USER=Partizand
dh-make-perl --vcs no --email partizand@gmail.com --build
# dh-make-perl --vcs no --email partizand@gmail.com --build-source
