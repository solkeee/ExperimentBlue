#!/bin/bash
apt-get update -y
apt-get install -y expect
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y install mysql-server

# Not required in actual script
MYSQL_ROOT_PASSWORD=root

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root:\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Would you like to setup VALIDATE PASSWORD plugin?\"
send \"n\r\"
expect \"Change the password for root ?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"n\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
sudo su
echo "$SECURE_MYSQL"
echo "Updating mysql configs in /etc/mysql/my.cnf."
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
echo "Updated mysql bind address in /etc/mysql/my.cnf to 0.0.0.0 to allow external connections."

echo "Creating Db test ..."
sudo mysql -uroot -e "CREATE DATABASE test;"
echo "Creation of Db test complete."

echo "Assigning mysql user dbcon access on %."
sudo mysql -u dbcon -pdbconpwd2018 --execute "GRANT ALL PRIVILEGES ON *.* TO 'dbcon'@'%' IDENTIFIED BY 'dbconpwd2018' with GRANT OPTION; FLUSH PRIVILEGES;" test
echo "Assigned mysql user dbcon access on all hosts."

sudo service mysql stop
sudo service mysql start


#sudo su
#sudo mysql -uroot -e "CREATE DATABASE test;"
#sudo mysql -e "CREATE USER 'demouser'@'localhost' IDENTIFIED BY 'demopwd';"
#sudo mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'root'@'%';"
#sudo mysql -e "FLUSH PRIVILEGES;"
apt-get purge -y expect
