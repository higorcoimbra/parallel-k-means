#! /bin/bash

cat map_test_file | egrep ^$1 | cut -d ' ' -f 2
