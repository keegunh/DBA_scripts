--NBMCMT_MAIL_L ���̺��� ȣ��Ǵ� ������Ʈ ����Ʈ
select * from sys.dm_sql_referencing_entities('dbo.NBMCMT_MAIL_L', 'OBJECT')
--��� : NBMCMP_SEND_MAIL

-- NBMCMP_SEND_MAIL ���ν����� ȣ���ϴ� ������Ʈ ����Ʈ
select * from sys.dm_sql_referenced_entities('dbo.NBMCMP_SEND_MAIL', 'OBJECT')




--NBMMDP_MST_XRATE �� ����ϴ� ������Ʈ ����Ʈ Ȯ��
select * from sys.dm_sql_referencing_entities('dbo.NBMMDP_MST_XRATE', 'OBJECT')
NBMMDP_MST_EXEC_CALL

--NBMMDP_MST_XRATE �� ����ϴ� ������Ʈ ����Ʈ Ȯ��
select * from sys.dm_sql_referenced_entities('dbo.NBMMDP_MST_XRATE', 'OBJECT')
