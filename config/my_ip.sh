#!/bin/bash

#get IP used for defalt route (usually en0)
IP=$(hostname  -I | cut -f1 -d' ');

sshpass -f /home/pi/pass_file ssh root@192.168.1.169 "echo $IP > /tmp/mountd/disk1_part1/shared/ip_stampante.txt"
