# Install MySQL 8.0.32 on Redhat 9.3
https://access.redhat.com/documentation/fr-fr/red_hat_enterprise_linux/9/html/configuring_and_using_database_servers/installing-mysql_assembly_using-mysql
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022	
sudo yum update
sudo dnf list mysql* --showduplicates
sudo dnf install mysql-server-8.0.32-1.el9_2.x86_64
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service
sudo mysql_secure_installation
# validate password -> No
# New password -> mysql123
# Remove anonymous users -> No
# Disallow root login remotely -> No
# Remove test database and access to it -> No
# Reload privilege tables now -> Yes
mysql -u root -h localhost -P 3306 -pmysql123
CREATE USER 'root'@'%' IDENTIFIED BY 'mysql123';  -- create root that can access the instance from all hosts
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
