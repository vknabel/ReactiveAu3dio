#!/bin/bash

# Installs the Tailor package.

wget ${TAILOR_RELEASE_ARCHIVE} -O /tmp/tailor.tar
tar -xvf /tmp/tailor.tar
export PATH=$PATH:$PWD/tailor/bin/
