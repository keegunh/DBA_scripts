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

# Install percona xtrabackup
# percona is version sensitive
sudo yum install \
https://repo.percona.com/yum/percona-release-latest.\
noarch.rpm
sudo percona-release enable-only tools release
sudo yum install percona-xtrabackup-80

# check versions
cat /etc/redhat-release
mysql --version
rpm -q mysql-server-8.0.32-1.el9_2.x86_64
xtrabackup --version