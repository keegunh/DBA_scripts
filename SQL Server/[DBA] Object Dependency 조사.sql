--NBMCMT_MAIL_L 테이블이 호출되는 오브젝트 리스트
select * from sys.dm_sql_referencing_entities('dbo.NBMCMT_MAIL_L', 'OBJECT')
--결과 : NBMCMP_SEND_MAIL

-- NBMCMP_SEND_MAIL 프로시저가 호출하는 오브젝트 리스트
select * from sys.dm_sql_referenced_entities('dbo.NBMCMP_SEND_MAIL', 'OBJECT')




--NBMMDP_MST_XRATE 를 사용하는 오브젝트 리스트 확인
select * from sys.dm_sql_referencing_entities('dbo.NBMMDP_MST_XRATE', 'OBJECT')
NBMMDP_MST_EXEC_CALL

--NBMMDP_MST_XRATE 가 사용하는 오브젝트 리스트 확인
select * from sys.dm_sql_referenced_entities('dbo.NBMMDP_MST_XRATE', 'OBJECT')
