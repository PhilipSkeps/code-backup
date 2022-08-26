#!/bin/bash

echo ':('
echo -n 'Loading['
for i in {1..40}; do
   echo -n 'X'
   sleep 0.05
done
echo ']'
echo -e '\r\033[2A\033[0K:)\033[2B\033'

