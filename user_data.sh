#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -xe

export DEBIAN_FRONTEND=noninteractive

# apt update and install necessary packages
apt-get update -y
apt-get install -y apache2 php php-mysql git mysql-client composer

systemctl enable apache2
systemctl start apache2

cd /var/www

mv html html.bak

# clone the project and rename to html folder
git clone https://github.com/connect2sazad/online-food-ordering-system-in-php.git html

# update app config file to store rds details
cd html/connection
mv db.config db.config.bak
echo "[database]" >> db.config
echo "host = ${db_host}" >> db.config
echo "dbname = ${db_name}" >> db.config
echo "username = ${db_username}" >> db.config
echo "password = ${db_password}" >> db.config

# install aws sdk using composer
cd ..
composer require aws/aws-sdk-php

# check rds mysql conn and import sql file from git clone peoject to rds mysql
# Wait until RDS is accepting connections
until mysqladmin ping -h "${db_host}" -u "${db_username}" -p"${db_password}" --silent
do
    echo "Waiting for RDS..."
    sleep 10
done

# import sql
mysql -h "${db_host}" \
      -P "${db_port}" \
      -u "${db_username}" \
      -p"${db_password}" mysql < /var/www/html/SQL/online_rest.sql