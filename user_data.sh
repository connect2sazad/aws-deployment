#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -xe

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y apache2 php git mysql-client

systemctl enable apache2
systemctl start apache2

cd /var/www

mv html html.bak

git clone https://github.com/connect2sazad/online-food-ordering-system-in-php.git html

