#!/bin/bash


status=$(sudo systemctl status sshd.service)
if [[ $status =~ \(running\) ]]; then
    sudo systemctl stop sshd.service
    sudo systemctl disable sshd.service
else 
    sudo systemctl enable sshd.service
    sudo systemctl start sshd.service
fi
sudo systemctl status sshd.service
