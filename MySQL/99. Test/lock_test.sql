SHOW VARIABLES LIKE '%innodb_lock%';

CREATE SCHEMA HKG_TEST;


## TEST할 테이블 생성
CREATE TABLE HKG_TEST.TEST ( id INT);
INSERT INTO HKG_TEST.TEST VALUES  (1);
 
## Session 1
START TRANSACTION;
UPDATE HKG_TEST.TEST SET ID=1 WHERE ID=100;
ROLLBACK;

LOCK TABLES HKG_TEST.TEST READ;
UNLOCK TABLES;
 
## SESSION 2
START TRANSACTION;
UPDATE HKG_TEST.TEST SET ID=1000 WHERE ID=1;
ROLLBACK;

LOCK TABLES HKG_TEST.TEST WRITE;
UNLOCK TABLES;


DROP TABLE HKG_TEST.TEST;
DROP SCHEMA HKG_TEST;




0	50	11:00:25	SELECT straight_join
    w.trx_mysql_thread_id waiting_thread,
    w.trx_id waiting_trx_id,
    w.trx_query waiting_query,
    b.trx_mysql_thread_id blocking_thread,
    b.trx_id blocking_trx_id,
    b.trx_query blocking_query,
    bl.lock_id blocking_lock_id,
    bl.lock_mode blocking_lock_mode,
    bl.lock_type blocking_lock_type,
    bl.lock_table blocking_lock_table,
    bl.lock_index blocking_lock_index,
    wl.lock_id waiting_lock_id,
    wl.lock_mode waiting_lock_mode,
    wl.lock_type waiting_lock_type,
    wl.lock_table waiting_lock_table,
    wl.lock_index waiting_lock_index
  FROM
    information_schema.INNODB_LOCK_WAITS ilw ,
    information_schema.INNODB_TRX b , 
    information_schema.INNODB_TRX w , 
    information_schema.INNODB_LOCKS bl , 
    information_schema.INNODB_LOCKS wl
  WHERE
    b.trx_id = ilw.blocking_trx_id
    AND w.trx_id = ilw.requesting_trx_id
    AND bl.lock_id = ilw.blocking_lock_id
    AND wl.lock_id = ilw.requested_lock_id
 LIMIT 0, 1000	Error Code: 1109. Unknown table 'INNODB_LOCK_WAITS' in information_schema	0.015 sec