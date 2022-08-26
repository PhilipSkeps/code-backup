#!/bin/bash
OUTPUT=$(sudo du | sed -e '$!d' -e 's/[^0-9]*//g')
OUTPUT=$(bc <<< "scale=3; $OUTPUT/1000000")
echo -e "\n$OUTPUT GB\n"