#!/bin/bash

fr_disk `df -Ph .| tail -l |awk '{print $4}'`
echo 'Free disk:'$fr_disk

dd if=/dev/zero of=/swapfile1 bs=2048 count=2048000
chmod 0777 /swapfile1
mkswap /swapfile1
swapon swpafile1

free -m



