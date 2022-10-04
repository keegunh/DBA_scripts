-- ALTER 작업 진행률 확인
SELECT estc.NESTING_EVENT_ID
     , esmc.SQL_TEXT
     , estc.EVENT_NAME
     , estc.WORK_COMPLETED
     , estc.WORK_ESTIMATED
     , ROUND((estc.WORK_COMPLETED/estc.WORK_ESTIMATED)*100,2) as `PROGRESS(%)`
  FROM performance_schema.events_stages_current estc
 INNER JOIN performance_schema.events_statements_current esmc
    ON estc.NESTING_EVENT_ID = esmc.EVENT_ID
 WHERE estc.EVENT_NAME LIKE 'stage/innodb/alter%'
    OR estc.EVENT_NAME = 'stage/sql/copy to tmp table';

/*
	performance_schema 설정 확인
*/
SELECT NAME, ENABLED, TIMED
  FROM performance_schema.setup_instruments
 WHERE NAME LIKE 'stage/innodb/alter%';

SELECT *
  FROM performance_schema.setup_consumers
 WHERE NAME LIKE '%stages%';

/*
	performance_schema 설정 활성화
*/
UPDATE performance_schema.setup_instruments
   SET ENABLED = 'YES'
     , TIMED = 'YES'
 WHERE NAME LIKE 'stage/innodb/alter%';

UPDATE performance_schema.setup_consumers
   SET ENABLED = 'YES'
 WHERE NAME LIKE '%stages%';

/*
	performance_schema 설정 비활성화
*/
UPDATE performance_schema.setup_instruments
   SET ENABLED = 'NO'
     , TIMED = 'NO'
 WHERE NAME LIKE 'stage/innodb/alter%';

UPDATE performance_schema.setup_consumers
   SET ENABLED = 'NO'
 WHERE NAME LIKE '%stages%';