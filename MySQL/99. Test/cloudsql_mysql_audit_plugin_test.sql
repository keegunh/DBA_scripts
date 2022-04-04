-- GCP : cloudsql_mysql_audit 플러그인 테스트 

SHOW GLOBAL VARIABLES LIKE '%general_log%';
select * from mysql.general_log;

SHOW GLOBAL VARIABLES LIKE '%slow_query%';
select * from mysql.slow_log;

SHOW GLOBAL VARIABLES LIKE '%cloudsql%';
SELECT * FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE '%cloudsql%';

CALL mysql.cloudsql_create_audit_rule('*','*','*','*','B',1,@outval,@outmsg);
CALL mysql.cloudsql_create_audit_rule('root@%','HKG_TEST','*','*','B',1,@outval,@outmsg);
SELECT @outval, @outmsg;

CALL mysql.cloudsql_list_audit_rule('*',@outval,@outmsg);
SELECT @outval, @outmsg;

CALL mysql.cloudsql_delete_audit_rule('1',1,@outval,@outmsg);
SELECT @outval, @outmsg;

SHOW GLOBAL VARIABLES LIKE '%err%';

SHOW GLOBAL VARIABLES LIKE '%temp%';
SHOW GLOBAL VARIABLES LIKE '%performance%';

select * from information_schema.tables where table_type = 'BASE TABLE' AND ENGINE <> 'InnoDB';




CREATE SCHEMA HKG_TEST;

CREATE TABLE HKG_TEST.HKG_TEST(
	C1 INTEGER COMMENT 'C1'
) PARTITION BY LIST (C1) (
	PARTITION NO1 VALUES IN (1),
	PARTITION NO2 VALUES IN (2)
);
INSERT INTO HKG_TEST.HKG_TEST(C1) VALUES (1);
INSERT INTO HKG_TEST.HKG_TEST(C1) VALUES (2);
COMMIT;
SELECT * FROM HKG_TEST.HKG_TEST;

TRUNCATE TABLE HKG_TEST.HKG_TEST;

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'HKG_TEST';
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'HKG_TEST';
SELECT * FROM INFORMATION_SCHEMA.PARTITIONS WHERE TABLE_NAME = 'HKG_TEST';


DROP TABLE HKG_TEST.HKG_TEST;
DROP SCHEMA HKG_TEST;






정재문님, 안녕하세요.
황기근입니다.

제가 문제를 잘 정의하지 못한 것 같네요. 양해부탁드립니다.
우선 general log 과 slow log은 기존 테스트를 통해서 log explorer에 정상 조회됨을 확인했습니다. 본 케이스를 통해서 도움을 요청드리는 부분은 audit log의 기능 구현입니다.
제가 구체적으로 audit log 를 통해 확인하고자 하는 기능은 공유해주신 링크에 있는 설명처럼  특정 DB 오브젝트 또는 전체 DB에 대한 DML, DDL, DCL 로그가 log explorer에 남는지 여부입니다.
테스트를 통해 기능이 정상 작동하지 않는다고 느낀 부분을 캡쳐하여 ppt파일로 첨부해드렸습니다. 테스트 스크립트도 같이 첨부해드립니다.
audit log 기능을 프로젝트에서 사용하려고 하고 있는데 정상적으로 작동 가능하도록 가이드 요청드립니다.

감사합니다.