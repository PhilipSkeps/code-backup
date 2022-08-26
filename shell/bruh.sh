#!/bin/bash

pid=$!
mpg123 /home/philip/HomeDir/misc/dontlistentothis.mp3 &>/dev/null &
pid=$!
while kill -0 $pid 2> /dev/null; do
    echo -e "\e[1;93mBRUH!!"
    sleep 1
done