#!/bin/bash

pid=$!
mpg123 /home/pskeps/Music/'Reverb Fart - Sound Effect (HD).mp3' &>/dev/null &
pid=$!
echo -e "currently farting"
while kill -0 $pid 2> /dev/null; do
    sleep 1
done
echo -e "finished farting"
