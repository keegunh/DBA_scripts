/*
	cloudsql_mysql_audit 플래그 적용 확인
*/
SELECT * FROM INFORMATION_SCHEMA.PLUGINS WHERE PLUGIN_NAME LIKE '%cloudsql%';

/*
	audit rule 추가
*/
CALL mysql.cloudsql_create_audit_rule('*','*','*','*','B',1,@outval,@outmsg);
CALL mysql.cloudsql_create_audit_rule('root@%','HKG_TEST','*','*','B',1,@outval,@outmsg);
SELECT @outval, @outmsg;

/*
	audit rule 적용 확인
*/
CALL mysql.cloudsql_list_audit_rule('*',@outval,@outmsg);
SELECT @outval, @outmsg;

/*
	audit rule 삭제
*/
-- CALL mysql.cloudsql_delete_audit_rule('1',1,@outval,@outmsg);
-- SELECT @outval, @outmsg;





/*
	테스트 스키마 및 테이블 생성, 데이터 조작
*/
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