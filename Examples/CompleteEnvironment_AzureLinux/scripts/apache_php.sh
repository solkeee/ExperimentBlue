#!/bin/bash\
export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install apache2
pub_ip=$(wget -qO- http://ipecho.net/plain)
sudo bash -c "echo 'ServerName $pub_ip' >> /etc/apache2/apache2.conf"
sudo service apache2 restart\
sudo add-apt-repository ppa:ondrej/php -y && sudo apt-get -y update
sudo apt install -y php7.1 libapache2-mod-php7.1 php7.1-mysql php-common php7.1-cli php7.1-common php7.1-json php7.1-opcache php7.1-readline\
#update apache2 to use php7.1
sudo a2enmod php7.1
#restart apache2
sudo service apache2 restart
#echo "Setting ownership on /var/www"
sudo chown -R www-data:www-data /var/www 
wget  -O /var/www/html/demo.php 
sudo chown -R www-data:www-data /var/www/html/demo.php
