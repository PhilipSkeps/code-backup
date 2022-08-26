#!/bin/bash

read -p "What number do you want to send to: " number
read -p "What message do you want to send: " text
read -p "How many times do you want to send it: " n
carrier=@vtext.com

sendto="$number$carrier"

i=0
while [ $i -lt $n ]; do
    i=$((i+1))
    echo "$text" | mail -s '' $sendto
done

echo "Sent the Message"
echo "$text" | mail -s '' $sendto