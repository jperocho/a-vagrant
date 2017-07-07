#!/bin/bash
# file: init.sh

SITE_NAME=$1
# create random password
PASSWDDB="$(openssl rand -base64 12)"
GREEN="\033[0;32m"
RED="\033[0;31m"
WWW_DIRECTORY="/vagrant/www"
TYPE=$(grep -A3 'type:' /vagrant/config.yml | cut -d ":" -f 2 | sed 's/^[ \t]*//;s/[ \t]*$//')

nginx-config() {
    sudo rm /etc/nginx/sites-enabled/default
    sudo rm /etc/nginx/sites-available/default

sudo tee /etc/nginx/sites-available/$SITE_NAME > /dev/null <<'EOF'
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        return 302 https://$host$request_uri;
}
server {

        listen 443 ssl http2 default_server;
        listen [::]:443 ssl http2 default_server;
        include snippets/self-signed.conf;
        include snippets/ssl-params.conf;

        root /vagrant/www/;

        index index.html index.htm index.php;

        server_name _;

        location / {
                try_files $uri $uri/ =404;
        }

        location /phpmyadmin {
          root /usr/share/;
          index index.php;
          try_files $uri $uri/ =404;

          location ~ ^/phpmyadmin/(doc|sql|setup)/ {
            deny all;
          }

          location ~ /phpmyadmin/(.+\.php)$ {
            fastcgi_pass unix:/run/php/php7.0-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
            include snippets/fastcgi-php.conf;
          }
         }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }
}

EOF

    sudo ln -s /etc/nginx/sites-available/$SITE_NAME /etc/nginx/sites-enabled/
    sudo nginx -t && sudo systemctl restart nginx
}

wordpress() {
    echo -e "${GREEN}---------- Fetching Latest Wordpress Core"
    curl -O https://wordpress.org/latest.tar.gz
    echo ""

    echo -e "${GREEN}---------- Extracting Wordpress"
    tar zxf latest.tar.gz
    rm -rf latest.tar.gz
    mv wordpress www
    echo ""

    echo -e "${GREEN}---------- Creating Database"
    mysql -uroot -pmysql -e "CREATE DATABASE ${SITE_NAME//./_};"
    mysql -uroot -pmysql -e "CREATE USER ${SITE_NAME//./_}@localhost IDENTIFIED BY '${PASSWDDB}';"
    mysql -uroot -pmysql -e "GRANT ALL PRIVILEGES ON ${SITE_NAME//./_}.* TO '${SITE_NAME//./_}'@'localhost';"
    mysql -uroot -pmysql -e "FLUSH PRIVILEGES;"
    echo ""

    echo -e "${GREEN}---------- Setup nginx config"
    nginx-config
    echo ""

    echo -e "${GREEN}---------- Adding DB credentials to wp-config.php"
    cp /vagrant/www/wp-config-sample.php /vagrant/www/wp-config.php
    sed -i "/DB_HOST/s/'[^']*'/'localhost'/2" /vagrant/www/wp-config.php
    sed -i "/DB_NAME/s/'[^']*'/'${SITE_NAME//./_}'/2" /vagrant/www/wp-config.php
    sed -i "/DB_USER/s/'[^']*'/'${SITE_NAME//./_}'/2" /vagrant/www/wp-config.php
    sed -i "/DB_PASSWORD/s/'[^']*'/'${PASSWDDB}'/2" /vagrant/www/wp-config.php
    cd /vagrant/www
    find . -name wp-config.php -print | while read line
    do
        curl http://api.wordpress.org/secret-key/1.1/salt/ > wp_keys.txt
        sed -i.bak -e '/put your unique phrase here/d' -e \
        '/AUTH_KEY/d' -e '/SECURE_AUTH_KEY/d' -e '/LOGGED_IN_KEY/d' -e '/NONCE_KEY/d' -e \
        '/AUTH_SALT/d' -e '/SECURE_AUTH_SALT/d' -e '/LOGGED_IN_SALT/d' -e '/NONCE_SALT/d' $line
        cat wp_keys.txt >> $line
        rm wp_keys.txt
    done
    echo ""
}

bedrock() {
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
    wp dotenv set WP_HOME https://${SITE_NAME}.local
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
}

if [ -d "$WWW_DIRECTORY" ];
then
    echo -e "${RED}Folder Exists"
else

    cd /vagrant

    case "$TYPE" in
    "wordpress")
        wordpress
        ;;
    "bedrock")
        bedrock
        ;;
    *)
        echo "Config type not recognize"
        ;;
    esac

fi
