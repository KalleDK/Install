#!/bin/bash
sudo apt-get install screen
screen -S cec-client -d -m -- cec-client -d 1 -o Laura
su - pi -c "screen -S cec-client -d -m -- cec-client -d 1 -o Laura"
su - pi -c "screen -S cec-client -X stuff 'scan
'"
