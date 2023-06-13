#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo systemctl restart docker
    echo "Docker installed successfully."
else
    echo "Docker is already installed."
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully."
else
    echo "Docker Compose is already installed."
fi

# Check if site name argument was provided
if [ -z "$1" ]; then
  echo "Please provide a site name as an argument."
  exit 1
fi

# Create an /etc/hosts entry for the site
site_name="$1"
echo "127.0.0.1:8000 $site_name" >> /etc/hosts
 
 # Create a directory for the WordPress site
mkdir wordpress-file
cd wordpress-file

# Create public and nginx file
echo "Creating nginx configuration file"
mkdir public nginx
cd nginx
cat > default.conf << EOF
events {}
http{
    server {
        listen 80;
        server_name $host;
        root /usr/share/nginx/html;
        index  index.php index.html index.html;

        location / {
            try_files $uri $uri/ /index.php?$is_args$args;
        }

        location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass phpfpm:9000;
            fastcgi_index   index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
        }
    }
} 
EOF
echo "Done"
echo "Creating index.php file in public"
cd ..
cd public
cat > index.php << EOF
<?php
phpinfo();
EOF
echo "Done"
cd ..
echo "Creating docker-compose file ..."
cat > docker-compose.yaml << EOF 
version: '3'

services:
  #databse
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: password
    networks:
      - wpsite
  #php-fpm
  phpfpm:
    image: php:fpm
    depends_on:
      - db
    ports:
      - '9000:9000'
    volumes: ['./public:/usr/share/nginx/html']
    networks:
      - wpsite
  #phpmyadmin
  phpmyadmin:
    depends_on:
      - db
    image: phpmyadmin/phpmyadmin
    restart: always
    ports:
      - '8080:80'
    environment:
      PMA_HOST: db
      MYSQL_ROOT_PASSWORD: password
    networks:
      - wpsite
  #wordpress
  wordpress:
    depends_on: 
      - db
    image: wordpress:latest
    restart: always
    ports:
      - '8000:80'
    volumes: ['./:/var/www/html']
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    networks:
      - wpsite
  #nginx
  proxy:
    image: nginx:1.17.10
    depends_on:
      - db
      - wordpress
      - phpmyadmin
      - phpfpm
    ports:
      - '8001:80'
    volumes: 
      - ./:/var/www/html
      - ./nginx/default.conf:/etc/nginx/nginx.conf
    networks:
      - wpsite
networks:
  wpsite:
volumes:
  db_data:
EOF
echo "Done"
fuser -k 8000/tcp 9000/tcp 8081/tcp 8080/tcp
echo "Creating LEMP stack in docker for wordpress site"
docker-compose up -d
echo "Servers created successfully"

# prompting user to open site in browser
echo "Site is up and healthy now. Open $site_name in any browser to view it."
echo "Or click on the link -> http://localhost:8000"

# Adding subcommands to enbale/disable
if [ "$2" == "enable" ]; then
 docker-compose start
elif [ "$2" == "disable" ]; then
 docker-compose stop
fi

# Adding subcommands to delete site
if [ "$2" == "delete" ]; then
 docker-compose down -v
 #removing hosts entry
 sed -i "/$site_name/d" /etc/hosts
 #removing all local files
 rm -rf ./
fi

