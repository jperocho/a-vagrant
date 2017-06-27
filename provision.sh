#!/bin/bash
# file: init.sh

SITE_NAME=$1
# create random password
PASSWDDB="$(openssl rand -base64 12)"
GREEN="\033[0;32m"
cd /vagrant

echo -e "${GREEN}---------- Fetching Bedrock"
git clone https://github.com/roots/bedrock.git www
echo ""

echo -e "${GREEN}---------- Creating Database"
mysql -uroot -pmysql -e "CREATE DATABASE ${SITE_NAME//./_};"
mysql -uroot -pmysql -e "CREATE USER ${SITE_NAME//./_}@localhost IDENTIFIED BY '${PASSWDDB}';"
mysql -uroot -pmysql -e "GRANT ALL PRIVILEGES ON ${SITE_NAME//./_}.* TO '${SITE_NAME//./_}'@'localhost';"
mysql -uroot -pmysql -e "FLUSH PRIVILEGES;"
echo ""

echo -e "${GREEN}---------- Applying Custom composer.json"
rm /vagrant/www/composer.json
cp /vagrant/overrides/bedrock_composer.json /vagrant/www/composer.json
echo ""

echo -e "${GREEN}---------- Generating .env File"
cd /vagrant/www
wp dotenv init --template=.env.example --with-salts
wp dotenv set DB_NAME ${SITE_NAME//./_}
wp dotenv set DB_USER ${SITE_NAME//./_}
wp dotenv set DB_PASSWORD ${PASSWDDB}
wp dotenv set WP_HOME http://${SITE_NAME}.local
# mv /home/vagrant/.env /vagrant/www
echo ""

echo -e "${GREEN}---------- Installing Bedrock"
composer install
echo ""

echo -e "${GREEN}---------- Installing Sage Theme"
cd /vagrant/www/web/app/themes
composer create-project roots/sage theme_$1 8.5.1

echo -e "${GREEN}---------- Installing Plugins and Configuring database"
cd /vagrant/www/
composer update
echo ""
