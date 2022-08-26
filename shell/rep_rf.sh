#!/bin/bash

iter=$1
frq=$2
time=$(bc <<< "scale=2;1/$frq")
#time=$(bc <<< "scale=2;1/($RANDOM % 100 + 1)")
i=1
while [[ $i -le $iter ]]; do
    mpg123 /home/pskeps/Music/'Reverb Fart - Sound Effect (HD).mp3' &>/dev/null &
    sleep $time
    i=$(($i+1))
done
