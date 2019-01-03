#!/bin/bash
sudo docker stop $(sudo docker ps -a -q)
sudo docker system prune --all
echo "Removed All Containers"