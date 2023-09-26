#!/bin/bash

((ifconfig tun0 | grep -E 'inet ' -B 1) || (ifconfig eth0 | grep -E 'inet ' -B 1) || (ifconfig wlan0 | grep -E 'inet ' -B 1)) 2>/dev/null | tr -d '\n' | awk '{ print $1" ("$6")" }'