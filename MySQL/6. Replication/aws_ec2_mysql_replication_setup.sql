-- 1. APPLY ON BOTH SOURCE AND REPLICA
CREATE USER 'root'@'%' IDENTIFIED BY 'mysql123';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
SELECT host, user, super_priv FROM mysql.user;


-- Setup security group so that it allows 3306 traffic between the same security group


-- 2. CONFIGURE SOURCE (private IP: 10.0.0.101)
mysql -u root -h 10.0.0.101 -P 3306 -pmysql123
show variables like '%log_bin%';
show variables like '%binlog_format%';
show variables like '%binlog%';
show binary logs;
show variables like '%server_id%';
SET PERSIST server_id = 1;
show variables like 'innodb_flush_log_at_trx_commit';
SET PERSIST innodb_flush_log_at_trx_commit=1;
show variables like 'sync_binlog';
SET PERSIST sync_binlog=1;
sudo vi /var/lib/mysql/mysqld-auto.cnf
-- RESET PERSIST;

-- create user for replication
CREATE USER 'repl'@'%' IDENTIFIED BY 'mysql123';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';

FLUSH TABLES WITH READ LOCK; -- execute in another client session
-- Use mysqldump to migrate data from the source to the replica

SHOW MASTER STATUS; -- check replication position in the binary log. Use this to fill in 'CHANGE REPLICATION SOURCE TO ' command in the replica.

UNLOCK TABLES; -- unlocks FLUSH TABLES WITH READ LOCK




-- 3. CONFIGURE REPLICA (private IP: 10.0.0.135)
mysql -u root -h 10.0.0.135 -P 3306 -pmysql123
SHOW VARIABLES LIKE '%log_bin%';
SHOW VARIABLES LIKE '%binlog_format%';
SHOW VARIABLES LIKE '%binlog%';
SHOW BINARY LOGS;
SHOW VARIABLES LIKE '%server_id%';
SET PERSIST server_id = 2;
SHOW VARIABLES LIKE '%log_replica_updates%'; -- required for A > B > C replication topology
SET PERSIST log_replica_updates = 1;
sudo vi /var/lib/mysql/mysqld-auto.cnf

-- must delete auto.cnf so that UUIDs of the source and the replica do not overlap.
-- Otherwise Replica_IO_Running will fail
sudo systemctl stop mysqld
rm /var/lib/mysql/auto.cnf
sudo systemctl start mysqld

CHANGE REPLICATION SOURCE TO
    SOURCE_HOST='10.0.0.101',
    SOURCE_PORT=3306,
    SOURCE_USER='repl',
    SOURCE_PASSWORD='mysql123',
    SOURCE_LOG_FILE='binlog.000020',
    SOURCE_LOG_POS=157,
    GET_SOURCE_PUBLIC_KEY=1;
SHOW WARNINGS;
START REPLICA;
SHOW REPLICA STATUS\G


-- 4. CHECK REPLICATION : SOURCE
SHOW TABLES FROM employees;
USE employees;
DROP TABLE t1;
CREATE TABLE t2(c1 NUMERIC PRIMARY KEY);
INSERT INTO t2 VALUES (2);
COMMIT;
SELECT * FROM t2;

INSERT INTO employees VALUES(777777, now(), 'dummy', 'dummy', 'M', now());
COMMIT;
SELECT * FROM employees WHERE emp_no=777777;


-- 5. CHECK REPLICATION : REPLICA
SHOW TABLES FROM employees;
USE employees;
SELECT * FROM employees WHERE emp_no=777777;
SELECT * FROM t2;