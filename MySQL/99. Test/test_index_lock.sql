/*
*	인덱스와 락에 관계에 대한 설명
*	MySQL은 변경해야 할 레코드를 찾기 위해 검색한 인덱스의 레코드를 모두 락을 걸어야 한다.
*/


-- TEST PREPARATION
USE ERPAPP;
CREATE TABLE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 LIKE ERPAPP.HR_IF_ASG_HIST_RCV;
INSERT INTO ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SELECT * FROM ERPAPP.HR_IF_ASG_HIST_RCV;
COMMIT;

DESC ERPAPP.HR_IF_ASG_HIST_RCV;
DESC ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725;
SHOW KEYS FROM ERPAPP.HR_IF_ASG_HIST_RCV;
SHOW KEYS FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725;

SELECT COUNT(1) FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 WHERE SEQ_ID < 182000;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SET TRANSFER_FLAG = 'N' WHERE SEQ_ID < 182000;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SET CRT_DT = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d%H%i%s'), REP_COMP_CD = 'LGES' WHERE TRANSFER_FLAG = 'N' AND SEQ_ID = 181267;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SET CRT_DT = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d%H%i%s'), REP_COMP_CD = 'LGC' WHERE TRANSFER_FLAG = 'N' AND SEQ_ID = 181269;
COMMIT;


SELECT COUNT(1) FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 WHERE TRANSFER_FLAG = 'N';
SELECT SEQ_ID, EMP_NO, SF_USER_ID, SF_PERSON_ID, TRANSFER_FLAG, CRT_DT, REP_COMP_CD FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 WHERE TRANSFER_FLAG = 'N';
SELECT SEQ_ID, EMP_NO, SF_USER_ID, SF_PERSON_ID, TRANSFER_FLAG, CRT_DT, REP_COMP_CD FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 WHERE TRANSFER_FLAG = 'N' AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d');

/*
PRIMARY					1	SEQ_ID
HR_IF_ASG_HIST_RCV_N01	1	TRANSFER_FLAG
HR_IF_ASG_HIST_RCV_N02	1	SF_USER_ID
HR_IF_ASG_HIST_RCV_N03	1	CRT_DT
HR_IF_ASG_HIST_RCV_N04	1	IF_GROUP_ID
HR_IF_ASG_HIST_RCV_N05	1	CPI_JOB_ID
*/


-- TEST POINT : 수정, 삭제를 위해 인덱스로 읽은 데이터는 무조건 lock이 걸린다. 해당 데이터가 나중에 인덱스 또는 테이블 수준에서 filter 되어 안 쓰인다고 해도 lock은 똑같이 걸린다.
-- tabular query plan 에서 rows를 보면 몇 건이 lock 걸리는 지 확인할 수 있다.

-- SESSION 1
USE ERPAPP;
SHOW KEYS FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725;
SELECT SEQ_ID, EMP_NO, SF_USER_ID, SF_PERSON_ID, TRANSFER_FLAG, CRT_DT, REP_COMP_CD FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 WHERE TRANSFER_FLAG = 'N';
SELECT SEQ_ID, EMP_NO, SF_USER_ID, SF_PERSON_ID, TRANSFER_FLAG, CRT_DT, REP_COMP_CD FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 WHERE TRANSFER_FLAG = 'N' AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d');

START TRANSACTION;
-- TESTCASE1 : 아래 UPDATE문은 HR_IF_ASG_HIST_RCV_N03 (CRT_DT)를 사용하는데 
-- 여기서 CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d') 에 해당하는 ROW는 모두 LOCK이 걸린다.
-- SESSION 1에서 SF_PERSON_ID 컬럼 값이 '400026', '400027' 인 ROW 모두 위 인덱스에서 위 조건절로 둘 다 UPDATE를 위해 읽었기 때문에
-- SESSION 1에서는 SF_PERSON_ID = '400026' 만 UPDATE 한다고 해도 SESSION 2에서는 SF_PERSON_ID = '400027'을 접근할 수 없다.
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SET TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s') WHERE TRANSFER_FLAG = 'N' AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d') AND SF_PERSON_ID = '400026';
ROLLBACK;

-- SESSION 2
USE ERPAPP;
START TRANSACTION;
-- TESTCASE1 : SF_PERSON_ID = '400027'을 접근 불가. SESSION 1의 LOCK 대기
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SET TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s') WHERE TRANSFER_FLAG = 'N' AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d') AND SF_PERSON_ID = '400027';
ROLLBACK;



-- 해결 방안 : 사용 중인 인덱스에 두 트랜잭션을 구분 지을 수 있는 컬럼을 추가한다.
-- 예를 들어 : REP_COMP_CD는 해당 트랜잭션의 대상 고객사를 의미한다.
SELECT DISTINCT REP_COMP_CD FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725;
/*
LGC
LGES
CNS
NULL
*/
-- 만약 SESSION 1 의 트랜잭션이 REP_COMP_CD = 'LGC'만 대상이고,
-- SESSION 2의 트랜잭션이 REP_COMP_CD = 'LGC'만 대상이라면
-- 아래와 같이 기존 CRT_DT만 사용하는 쿼리일 때 앞에 구분 컬럼이 추가된 인덱스를 새로 생성할 수 있다.
-- 그리고 UPDATE 조건절에도 해당 컬럼을 다음과 같이 추가하면 
-- CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d') AND REP_COMP_CD = 'LGES' 또는 'LGC'
-- 트랜잭션에서 UPDATE를 위해 락을 걸 때 보다 CRT_DT를 만족시키는 조건으로만 통으로 LOCK을 잡지 않고 REP_COMP_CD까지 포함해서 보다 세밀하게 락을 걸 수 있다.
ALTER TABLE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 ADD KEY HR_IF_ASG_HIST_RCV_N06(REP_COMP_CD, CRT_DT);
-- ALTER TABLE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 DROP KEY HR_IF_ASG_HIST_RCV_N06;


-- SESSION 1
START TRANSACTION;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SET TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s') WHERE TRANSFER_FLAG = 'N' AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d') AND SF_PERSON_ID = '400026' AND REP_COMP_CD = 'LGES';
ROLLBACK;

-- SESSION 2
START TRANSACTION;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SET TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s') WHERE TRANSFER_FLAG = 'N' AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d') AND SF_PERSON_ID = '400027' AND REP_COMP_CD = 'LGC';
ROLLBACK;








/* ---------------------------------------------------------------------------------------------------------------------------------------
MySQL 서버는 MySQL 엔진과 스토리지 엔진으로 구분되어 있습니다.

현재 SINGLEX HR CORE 프로젝트에서는 여러 스토리지 엔진 중 유일하게 레코드 기반의 Lock이 지원되는 InnoDB 엔진을 주로 사용하고 있습니다.



InnoDB 스토리지 엔진의 Lock도 record lock, gap lock, next key lock, auto increment lock 등 다양한 종류가 있지만
본 글에서는 가장 기본적인 record lock에 대해서 서술하도록 하겠습니다.

Oracle이나 SQL Server와 같은 일반적인 DBMS는 row를 수정하거나 삭제할 때 (update, delete) 해당 row만 잠그고 작업합니다.
즉 작업 중인 해당 row만 다른 트랜잭션에서 접근하지 못합니다.

MySQL InnoDB 스토리지 엔진의 record lock은 조금 다릅니다. (record 와 row 는 동일한 의미로 쓰겠습니다.)
InnoDB 스토리지 엔진은 row 에 lock을 걸 때 table row 자체가 아니라 인덱스의 row에 lock을 겁니다.
즉, 수정하거나 삭제하기 위해 검색한 모든 인덱스 레코드에 lock을 겁니다.

UPDATE를 하는데 만약 테이블에 인덱스가 하나도 없다면 내부적으로 자동 생성된 클러스터 인덱스를 이용해 잠금을 설정하고,
테이블을 FULL SCAN 하면서 전체 테이블 row가 lock이 걸립니다.







다음은 InnoDB 스토리지 엔진의 인덱스 lock이 어떻게 작동하는지 테스트한 내용입니다.

테스트 확인 사항 : 수정, 삭제를 위해 인덱스로 읽은 데이터는 무조건 lock이 걸리는지 확인. 해당 데이터가 나중에 인덱스 또는 테이블 수준에서 filter 되어 안 쓰인다고 해도 lock은 똑같이 걸리는지 확인

테스트 테이블 : ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725

테스트 데이터 : SEQ_ID 가 181267, 181269 인 row

참고 사항 : tabular query plan 에서 rows를 보면 몇 건이 lock 걸리는 지 확인할 수 있습니다.




-- 테스트 테이블 구성 : ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725
USE ERPAPP;
CREATE TABLE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 LIKE ERPAPP.HR_IF_ASG_HIST_RCV;
INSERT INTO ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SELECT * FROM ERPAPP.HR_IF_ASG_HIST_RCV;
COMMIT;

DESC ERPAPP.HR_IF_ASG_HIST_RCV;
DESC ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725;
SHOW KEYS FROM ERPAPP.HR_IF_ASG_HIST_RCV;
SHOW KEYS FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725;



-- 테스트 row 구성 : SEQ_ID 가 181267, 181269 인 row

SELECT COUNT(1) FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 WHERE SEQ_ID < 182000;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SET TRANSFER_FLAG = 'N' WHERE SEQ_ID < 182000;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SET CRT_DT = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d%H%i%s'), REP_COMP_CD = 'LGES' WHERE TRANSFER_FLAG = 'N' AND SEQ_ID = 181267;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 SET CRT_DT = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d%H%i%s'), REP_COMP_CD = 'LGC' WHERE TRANSFER_FLAG = 'N' AND SEQ_ID = 181269;
COMMIT;



-- 테스트 데이터 확인 

SELECT SEQ_ID, EMP_NO, SF_USER_ID, SF_PERSON_ID, TRANSFER_FLAG, CRT_DT, REP_COMP_CD
  FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725
WHERE TRANSFER_FLAG = 'N';




-- 테스트 데이터만 확인하는 쿼리

SELECT SEQ_ID, EMP_NO, SF_USER_ID, SF_PERSON_ID, TRANSFER_FLAG, CRT_DT, REP_COMP_CD
  FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725
WHERE TRANSFER_FLAG = 'N'
     AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d');




SHOW KEYS FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725;
테스트에서 사용할 인덱스는 HR_IF_ASG_HIST_RCV_N03 인덱스입니다 (CRT_DT 컬럼 사용)







-- 테스트1 
세션이 총 2개 필요합니다. SESSION 1에서 SF_PERSON_ID = '400026' row를 update 할 때 row 단위로만 lock이 걸린다면,
SESSION 2에서는 SF_PERSON_ID = '400027'를 update할 때 lock을 대기할 필요 없이 바로 접근이 가능해야 합니다.
하지만 SESSION 1에서 lock 을 잡고 있을 때 SESSION 2에서는 대기하는 것을 확인할 수 있습니다.



-- SESSION 1 : 트랜잭션을 시작한 후 종료하지 않고 lock을 잡고 있도록 함.
USE ERPAPP;
START TRANSACTION;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725
       SET TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
 WHERE TRANSFER_FLAG = 'N' AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d')
      AND SF_PERSON_ID = '400026';



-- SESSION 2 : SESSION 1이 lock을 잡고 있는 상태에서 SF_PERSON_ID = '400027' 데이터 lock 획득 시도. Lock을 대기하다가 세션이 끊긴 걸 확인할 수 있습니다.
USE ERPAPP;
START TRANSACTION;
-- TESTCASE1 : SF_PERSON_ID = '400027'을 접근 불가. SESSION 1의 LOCK 대기
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725
       SET TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
 WHERE TRANSFER_FLAG = 'N' AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d')
      AND SF_PERSON_ID = '400027';




-- Lock Monitoring Session : SESSION 2 가 SESSION 1의 LOCK을 대기하는 것을 확인할 수 있습니다.






-- row가 다름에도 불구하고 lock이 걸린 원인
SESSION 1, SESSION 2에서의 UPDATE문 모두 CRT_DT컬럼을 사용하는 HR_IF_ASG_HIST_RCV_N03 인덱스로 UPDATE할 row를 찾습니다.
SESSION 1에서 update문을 먼저 실행하고 나면
CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d') 조건절에 해당하는 모든 row는 lock이 걸립니다.
SESSION 2에서는 같은 조건절을 쓰고 따라서 같은 인덱스로 해당 row를 update 하려고 하니 SESSION 1 에서 lock을 잡고 있어서 대기하게 되는 것입니다. 



위는 session 1의 update문의 explain 플랜인데 "rows" 컬럼에 1건이 아니라 2건을 읽는 것을 확인할 수 있습니다. 이 때 읽는 건이 lock 걸리는 row 수 입니다.


조금 더 상세하게 설명해드리면.. SESSION 1의 UPDATE문을 다시 보겠습니다.

UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725
       SET TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
 WHERE TRANSFER_FLAG = 'N'
      AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d')
      AND SF_PERSON_ID = '400026';

위 쿼리는 HR_IF_ASG_HIST_RCV_N03 인덱스를 사용하고 이 인덱스는 CRT_DT 단일 컬럼으로 구성되어 있습니다.
즉, 이 쿼리는 CRT_DT가 조건절에 일치하는 데이터를 인덱스에서 읽어서 TRANSFER_FLAG, SF_PERSON_ID 조건절이 일치하지 않는 row는 모두 필터하는 방식으로 실행됩니다.
그러면 여기서 CRT_DT >= DATE_FORMAT... 을 만족하는 데이터 건수가 100건이면 100건 모두 lock이 걸립니다.
(TRANSFER_FLAG, CRT_DT, SF_PERSON_ID 조건절 모두 만족시키는 row만 lock을 거는 게 아닙니다.)
이게 왜 문제가 되냐 하면 UPDATE문 자체는 SF_PERSON_ID = '400026'를 만족하는 row 한 건만 수정하는데 100건의 row 에 대해 lock을 잡았기 때문이지요.
이렇게 LOCK이 걸리면 SESSION 2에서 CRT_DT >= DATE_FORMAT... AND SF_PERSON_ID = '400027' 등과 같이
같은 인덱스 row를 스캔하지만 다른 table row를 업데이트하는 쿼리도
SESSION 1이 읽은 인덱스 범위와 동일하기 때문에 SESSION 1의 lock을 대기할 수 밖에 없습니다.



-- 해결 방안
같은 테이블에 대한 동시 접근이 이뤄져야 하는 트랜잭션 간에 인덱스를 읽는 범위가 겹치지 않게 인덱스 컬럼을 조정해야 합니다.
예를 들어 여러 계열사 배치에서 HR_IF_ASG_HIST_RCV_BACKUP_20220725와 같은 테이블을 동시에 UPDATE 해야 한다면
계열사를 구분 짓는 COLUMN을 인덱스에 컬럼에 추가합니다.
위 테이블 예시의 경우 REP_COMP_CD 라는 컬럼이 계열사를 구분 짓는 컬럼입니다.
DISTINCT 값으로는 LGC, LGES, CNS, NULL 이 있습니다.

SELECT DISTINCT REP_COMP_CD FROM ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725;
--	LGC
--	LGES
--	CNS
--	NULL


이 경우 아래와 같이 REP_COMP_CD 컬럼을 인덱스 선두 컬럼으로 추가하고 UPDATE 조건절에 REP_COMP_CD 조건절을 적절하게 추가하면 
CNS 배치, LGC, 배치, LGES 배치에서 동일 테이블에 대해 LOCK 대기 없이 트랜잭션을 진행할 수 있습니다.



ALTER TABLE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725 ADD KEY HR_IF_ASG_HIST_RCV_N06(REP_COMP_CD, CRT_DT);



-- 테스트2

-- SESSION 1
START TRANSACTION;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725
       SET TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
 WHERE TRANSFER_FLAG = 'N' AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d')
      AND SF_PERSON_ID = '400026'
      AND REP_COMP_CD = 'LGES';



-- SESSION 2
START TRANSACTION;
UPDATE ERPAPP.HR_IF_ASG_HIST_RCV_BACKUP_20220725
       SET TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
 WHERE TRANSFER_FLAG = 'N' AND CRT_DT >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 7 DAY),'%Y%m%d')
      AND SF_PERSON_ID = '400027'
      AND REP_COMP_CD = 'LGC';



-- Lock Monitoring Session : SESSION 2 는 더 이상 SESSION 1의 LOCK을 대기하지 않습니다.



*/ ---------------------------------------------------------------------------------------------------------------------------------------