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


# MYSQLDUMP - backup
cd ~
date;\
mysqldump -u root --databases employees --flush-logs --single-transaction \
--compress --order-by-primary -p --source-data=2 > employees_dump.sql; \
date

# make random modifications in employees DB
mysql -u root -pmysql123
use employees;
create table t1(c1 numeric);
insert into t1 values (1);
insert into t1 values (2);
insert into t1 values (3);
commit;
select * from t1;
insert into employees values(999999, now(), 'dummy', 'dummy', 'M', now());
commit;
select * from employees.employees where emp_no=999999;

# drop employees DB
drop database employees;
exit

# MYSQLDUMP - restore
date; \
mysql -u root -pmysql123 < employees_dump.sql; \
date

# MYSQLBINLOG - check start and stop position, and apply logs until just before the point of failure
vi employees_dump.sql
# CHANGE MASTER TO MASTER_LOG_FILE='binlog.000010', MASTER_LOG_POS=157;  <--- the dumpfile contains the logfile and the position when mysqldump started.
sudo mysqlbinlog --start-position=157 /var/lib/mysql/binlog.000010 > statements.sql
vi statements.sql
# /drop database    <---- search for "drop database employees" and use the end_log_pos just before this. 
sudo mysqlbinlog --start-position=157 --stop-position=1629 /var/lib/mysql/binlog.000010 > statements.sql
# vi statements.sql  <---- make sure this .sql does not contain "drop database..." or whatever is the query that caused the failure.
mysql -u root -p < statements.sql