#! /bin/bash
sudo useradd developer
sudo passwd developer

sudo groupadd developers
sudo usermod -aG developers developer
