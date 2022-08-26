#!/bin/bash

for file in $(dir); do
    cd $file
    for files in $(dir); do
        if [[ $files =~ core.* ]]; then
            rm -r $files
        fi
    done
    cd ..
done
