# Load test data: empoyees.sql
# https://dev.mysql.com/doc/employee/en/
# this creates a sample database: employees DB
sudo dnf install unzip
unzip test_db-master.zip
cd test_db-master/
mysql -h localhost -P 3306 -u root -pmysql123 -t < employees.sql
mysql -h localhost -P 3306 -u root -pmysql123
SELECT table_schema "DB Name",
        ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" 
FROM information_schema.tables 
GROUP BY table_schema; 


# XTRABACKUP - backup 
cd ~
mkdir backup_xtrabackup
sudo xtrabackup --backup --user=root --password=mysql123 --stream=xbstream \
   --target-dir=backup_xtrabackup | split -d --bytes=500MB \
   - backup_xtrabackup/backup.xbstream

# make random modifications in employees DB
mysql -u root -pmysql123
use employees;
create table t1(c1 numeric);
insert into t1 values (4);
insert into t1 values (5);
insert into t1 values (6);
commit;
select * from t1;
insert into employees values(888888, now(), 'dummy', 'dummy', 'M', now());
commit;
select * from employees.employees where emp_no=888888;

# drop employees DB
drop database employees;
exit

# XTRABACKUP - clean mysql server directory
cd ~
sudo systemctl stop mysqld.service
mkdir backup_mysql
sudo cp -r /var/lib/mysql/* ~/backup_mysql
sudo rm -rf /var/lib/mysql/*

# XTRABACKUP - restore
cd ~
mkdir restore_xtrabackup
sudo xbstream -x -C restore_xtrabackup < backup_xtrabackup/backup.xbstream00
sudo xtrabackup --prepare  --target-dir=restore_xtrabackup
sudo xtrabackup --copy-back --target-dir=restore_xtrabackup
sudo chown -R mysql:mysql /var/lib/mysql/*
sudo systemctl start mysqld.service
mysql -u root -pmysql123

# MYSQLBINLOG - check start and stop position, and apply logs until just before the point of failure
cd restore_xtrabackup
sudo cat xtrabackup_binlog_info
# binlog.000012   157    <---- This is when xtrabackup backup started
sudo mysqlbinlog --start-position=157 ~/backup_mysql/binlog.000012  >  statements.sql
vi statements.sql
# /drop database    <---- search for "drop database employees" and use the end_log_pos just before this. 
sudo mysqlbinlog --start-position=157 --stop-position=1629 ~/backup_mysql/binlog.000012  >  statements.sql
# vi statements.sql  <---- make sure this .sql does not contain "drop database..." or whatever is the query that caused the failure.
mysql -u root -p < statements.sql