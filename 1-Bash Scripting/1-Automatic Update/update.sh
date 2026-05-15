#!/bin/bash
echo "Starting system update"
sudo apt update
sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove -y
sudo apt clean
echo "System updated with success"

