/*
QA3
PORTAL : erpapp / zbdpdl3APP@
LGC    : erpapp / QAtkaLGCap12@#
LGCNS  : erpapp / qa3APcns1!
LGES   : erpapp / QA3esAPP32!
PORTAL : erpview / zbdpdlWHGHL!
LGC    : erpview / QAwhghlLGC34%
LGCNS  : erpview / qa3WHGHLcns12#$
LGES   : erpview / QA3viewES3!
PORTAL : inorg / zbdpdlORG#$
LGC    : inorg / QAtkaLGCorg23@!
LGCNS  : inorg / qatkaORGcns3@
LGES   : inorg / QA3orgLGES1!
PORTAL : erpconv / 22EPDLXJzjsqjwjs#!
LGC    : erpconv / LGCzjsqjwjs@$
LGCNS  : erpconv / CNSzjsqjwjs*$
LGES   : erpconv / DPSTHFconv22$#

PRD
PORTAL : erpapp / !rkdmfp
LGC    : erpapp / prdLGC12#$
LGCNS  : erpapp / prdCNS54#@
LGES   : erpapp / prdLGES11!@
PORTAL : erpview / whghlrk@
LGC    : erpview / prdLGCwhghl5$
LGCNS  : erpview / prdCNSwhghl8!
LGES   : erpview / prdLGESwhghl9@
PORTAL : inorg / !dkfwlg
LGC    : inorg / prdLGCin23$
LGCNS  : inorg / prdCNSin12!@
LGES   : inorg / prdLGESin45^&

PORTAL : erpconv / 22RHDXHDwjsghksn&
LGCNS  : erpconv / CNSwjsghks:]
LGC    : erpconv / LGCwjsghks!3
LGES   : erpconv / LGESwjsghksm6
*/

show create user erpconv;
-- CORE / PORTAL
ALTER USER 'erpconv'@'%' IDENTIFIED BY '22RHDXHDwjsghksn&' REQUIRE NONE PASSWORD EXPIRE INTERVAL 3 DAY ACCOUNT UNLOCK PASSWORD HISTORY DEFAULT PASSWORD REUSE INTERVAL DEFAULT PASSWORD REQUIRE CURRENT DEFAULT;

-- CNS
ALTER USER 'erpconv'@'%' IDENTIFIED BY 'CNSwjsghks:]' REQUIRE NONE PASSWORD EXPIRE INTERVAL 3 DAY ACCOUNT UNLOCK PASSWORD HISTORY DEFAULT PASSWORD REUSE INTERVAL DEFAULT PASSWORD REQUIRE CURRENT DEFAULT;

-- LGC
ALTER USER 'erpconv'@'%' IDENTIFIED BY 'LGCwjsghks!3' REQUIRE NONE PASSWORD EXPIRE INTERVAL 3 DAY ACCOUNT UNLOCK PASSWORD HISTORY DEFAULT PASSWORD REUSE INTERVAL DEFAULT PASSWORD REQUIRE CURRENT DEFAULT;

-- LGES
ALTER USER 'erpconv'@'%' IDENTIFIED BY 'LGESwjsghksm6' REQUIRE NONE PASSWORD EXPIRE INTERVAL 3 DAY ACCOUNT UNLOCK PASSWORD HISTORY DEFAULT PASSWORD REUSE INTERVAL DEFAULT PASSWORD REQUIRE CURRENT DEFAULT;

SELECT ID
     , USER
     , HOST
     , DB
     , COMMAND
     , TIME AS TIME_SEC
     , TIME / 60 / 60 AS TIME_HOURS
     , STATE
     , CONCAT('KILL ', ID, ';') AS KILL_CMD
     , INFO
  FROM INFORMATION_SCHEMA.PROCESSLIST
 WHERE 1=1
   AND USER = 'erpconv'
 ORDER BY TIME DESC
;

-- INFORMATION_SCHEMA 스키마 사용해서 현재 트랜잭션 조회
SELECT
       t.trx_mysql_thread_id
     , CONVERT_TZ(t.trx_started, 'UTC', '+09:00') as trx_started
     , CONVERT_TZ(t.trx_wait_started, 'UTC', '+09:00') as trx_wait_started
     , t.trx_state
     , p.user
     , p.host
     , p.db
     , p.command
     , t.trx_query
     , t.trx_operation_state
     , t.trx_tables_in_use
     , t.trx_tables_locked
     , t.trx_rows_locked
     , t.trx_rows_modified
     , t.trx_isolation_level
     , CONCAT('KILL QUERY ', t.trx_mysql_thread_id, ';') AS kill_query
     , CONCAT('KILL ', t.trx_mysql_thread_id, ';') AS kill_session
  FROM information_schema.innodb_trx t
 INNER JOIN information_schema.processlist p
    ON p.id = t.trx_mysql_thread_id
 WHERE p.user = 'erpconv'
 ORDER BY 2
;