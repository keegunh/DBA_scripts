Session 1:

mysql> CREATE TABLE t1 (c1 INT) ENGINE=InnoDB;
mysql> START TRANSACTION;
mysql> SELECT * FROM t1;
The session 1 SELECT statement takes a shared metadata lock on table t1.

Session 2:

mysql> ALTER TABLE t1 ADD COLUMN x INT, ALGORITHM=INPLACE, LOCK=NONE;
The online DDL operation in session 2, which requires an exclusive metadata lock on table t1 to commit table definition changes, must wait for the session 1 transaction to commit or roll back.

Session 3:

mysql> SELECT * FROM t1;
The SELECT statement issued in session 3 is blocked waiting for the exclusive metadata lock requested by the ALTER TABLE operation in session 2 to be granted.

You can use SHOW FULL PROCESSLIST to determine if transactions are waiting for a metadata lock.

mysql> SHOW FULL PROCESSLIST\G
...
*************************** 2. row ***************************
     Id: 5
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 44
  State: Waiting for table metadata lock
   Info: ALTER TABLE t1 ADD COLUMN x INT, ALGORITHM=INPLACE, LOCK=NONE
...
*************************** 4. row ***************************
     Id: 7
   User: root
   Host: localhost
     db: test
Command: Query
   Time: 5
  State: Waiting for table metadata lock
   Info: SELECT * FROM t1
4 rows in set (0.00 sec)
Metadata lock information is also exposed through the Performance Schema metadata_locks table, 
which provides information about metadata lock dependencies between sessions, 
the metadata lock a session is waiting for, 
and the session that currently holds the metadata lock. 
For more information, see Section 27.12.13.3, “The metadata_locks Table”.