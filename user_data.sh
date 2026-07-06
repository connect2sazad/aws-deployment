#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -xe

export DEBIAN_FRONTEND=noninteractive

# apt update and install necessary packages
apt-get update -y
apt-get install -y \
    apache2 \
    git \
    mysql-client \
    composer \
    unzip \
    php \
    php-cli \
    libapache2-mod-php \
    php-mysql \
    php-curl \
    php-mbstring \
    php-xml \
    php-zip

systemctl enable apache2
systemctl start apache2

cd /var/www

rm -rf /var/www/html
mkdir -p /var/www/html

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
echo "s3_region  = ${s3_region}" >> db.config
echo "s3_bucket = ${s3_bucket}" >> db.config

# install aws sdk using composer
cd ..
export HOME=/root
export COMPOSER_HOME=/root/.composer
export COMPOSER_ALLOW_SUPERUSER=1
composer require aws/aws-sdk-php --no-interaction

# check rds mysql conn and import sql file from git clone peoject to rds mysql
# Wait until RDS is accepting connections
until mysql \
    -h "${db_host}" \
    -P "${db_port}" \
    -u "${db_username}" \
    -p"${db_password}" \
    -e "SELECT 1;" >/dev/null 2>&1
do
    echo "Waiting for RDS..."
    sleep 10
done

echo "RDS is ready"

# import sql
if mysql \
    -h "${db_host}" \
    -P "${db_port}" \
    -u "${db_username}" \
    -p"${db_password}" \
    "${db_name}" \
    < /var/www/html/SQL/online_rest.sql
then
    echo "SQL import successful."
else
    echo "SQL import failed."
fi