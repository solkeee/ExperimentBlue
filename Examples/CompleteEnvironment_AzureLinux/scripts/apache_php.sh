#!/bin/bash\
export DEBIAN_FRONTEND=noninteractive
echo "Running distro update and upgrade..."
sudo apt-get -y update && sudo apt-get -y upgrade
wait
echo "Completed distro update and upgrade..."
echo "Running apache2 install..."
sudo apt-get -y install apache2
wait
echo "Completed apache2 install..."
echo "Getting public IP ..."
pub_ip=$(wget -qO- http://ipecho.net/plain)
echo "Public IP : $pub_ip"
echo "Updating public ip in /etc/apache2/apache2.conf..."
sudo bash -c "echo 'ServerName $pub_ip' | dd of=/etc/apache2/apache2.conf"
echo "Updated public ip in /etc/apache2/apache2.conf..."
echo "restarting apache2 service..."
sudo service apache2 restart
wait
echo "Restarted apache2 service..."
echo "Adding Php repo ppa ondrej/php and run update..."
sudo add-apt-repository ppa:ondrej/php -y && sudo apt-get -y update
wait
echo "Added Php repo ppa ondrej/php..."
echo "Install Php and modules ..."
sudo apt install -y php7.1 libapache2-mod-php7.1 php7.1-mysql php-common php7.1-cli php7.1-common php7.1-json php7.1-opcache php7.1-readline\
wait
echo "Installation of Php and modules complete..."
echo "Updating apache2 to use php7.1 ..."
#update apache2 to use php7.1
sudo a2enmod php7.1
wait
echo "Completed updating apache2 to use php7.1 ..."
echo "restarting apache2 service ..."
#restart apache2
sudo service apache2 restart
wait
echo "Setting ownership on /var/www"
sudo chown -R www-data:www-data /var/www 
echo "get the demo.php from github"
wget https://raw.githubusercontent.com/solkeee/ExperimentBlue/master/Examples/CompleteEnvironment_AzureLinux/scripts/demo.php -O /var/www/html/demo.php 
echo "change file to read only : demo.php"
sudo chown -R www-data:www-data /var/www/html/demo.php
echo "changed file to read only : demo.php"
