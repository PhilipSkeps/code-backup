#!/bin/bash
if [ "$1" == -e ] || [ "$1" == -m ]; then
    if [ "$1" == '-e' ]; then
        echo 'Which filesystem would you like to eject'
    fi
    if [ "$1" == '-m' ]; then
        echo 'Which filesystem would you like to mount'
    fi
    filesystems=$(sudo fdisk -l | grep -o "dev/sd[b-zB-Z][0-9]\+")
    select filesystem in $filesystems; do
        if [ $filesystem ]; then
            if [ "$1" == '-e' ]; then
                sudo eject /$filesystem
                sleep 2
                if $(mount | grep -q "/$filesystem"); then 
                    echo "The USB is still mounted, something went wrong"
                else
                    echo "The USB is ejected, you can safely take it out"
                fi
            elif [ "$1" == '-m' ]; then
                sudo mount /$filesystem /mnt
                sleep 5
                if $(mount | grep -q "/$filesystem"); then 
                    echo 'The Filesystem was successfully mounted to the /mnt directory'
                else
                    echo "The USB was not mounted, something went wrong"
                fi
            fi
        break
        fi
    done
else
    echo 'please enter one option [-m; to mount a Filesystem or -e; to eject a Filesystem]'
fi

