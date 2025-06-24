----------------------------------------------------------------------------------
-- Managing SQL Tuning Sets
-- https://docs.oracle.com/database/121/TGSQL/tgsql_sts.htm#TGSQL516
----------------------------------------------------------------------------------


-- Creating a SQL Tuning Set
-- STS 생성
BEGIN
	DBMS_SQLTUNE.CREATE_SQLSET( 
		sqlset_name => 'SQLT_WKLD_STS_TEST'
	  , description => 'STS to store SQL from the private SQL area'
	);
END;

-- STS 삭제
BEGIN
	DBMS_SQLTUNE.DROP_SQLSET(
		sqlset_name => 'SQLT_WKLD_STS_TEST'
	);
END;

-- STS 생성/삭제 확인
SELECT * FROM DBA_SQLSET;
SELECT * FROM TABLE(DBMS_SQLTUNE.SELECT_CURSOR_CACHE('SQL_TEXT LIKE ''%/* bbb */%'' AND parsing_schema_name = ''SCOTT'' '));







-- Loading/Modifying a SQL Tuning SET
-- STS 내 SQL 추가/변경/삭제
DECLARE
  c_sqlarea_cursor DBMS_SQLTUNE.SQLSET_CURSOR;
BEGIN
 OPEN c_sqlarea_cursor FOR
   SELECT VALUE(p)
     FROM TABLE(
            DBMS_SQLTUNE.SELECT_CURSOR_CACHE(
              'SQL_TEXT LIKE ''%/* bbb */%'' AND parsing_schema_name = ''SCOTT'' ')
          ) p;

-- load the tuning set
  DBMS_SQLTUNE.LOAD_SQLSET (  
    sqlset_name     => 'SQLT_WKLD_STS_TEST'
,   populate_cursor =>  c_sqlarea_cursor 
);
END;
/

BEGIN
  DBMS_SQLTUNE.UPDATE_SQLSET ( 
      sqlset_name     => 'SQLT_WKLD_STS_TEST'    
,     sql_id          => 'gm2wgsa47cbay'    
,     attribute_name  => 'PRIORITY'         
,     attribute_value =>  1
);
END;
/

BEGIN
  DBMS_SQLTUNE.DELETE_SQLSET (
      sqlset_name  => 'SQLT_WKLD_STS_TEST'
--,     basic_filter => 'fetches > 100'
,     basic_filter => 'SQL_ID = ''47cbjqk5g2g5n'''
);
END;
/




-- Displaying the Contents of a SQL Tuning Set
-- STS 내 SQL 조회

--SELECT SQL_ID, PARSING_SCHEMA_NAME AS "SCH", SQL_TEXT, 
--       ELAPSED_TIME AS "ELAPSED", BUFFER_GETS
SELECT *
FROM   TABLE( DBMS_SQLTUNE.SELECT_SQLSET( 'SQLT_WKLD_STS_TEST' ) );

SELECT sql_id, parsing_schema_name as "SCH", sql_text, 
       buffer_gets as "B_GETS",
       disk_reads, ROUND(disk_reads/buffer_gets*100,2) "%_DISK"
FROM TABLE( DBMS_SQLTUNE.SELECT_SQLSET( 
            'SQLT_WKLD_STS_TEST',
            'buffer_gets >= 1000000' ) );







-- Transporting a SQL Tuning Set
/*
 * 1. source에서 CREATE_STGTAB_SQLSET으로 staging table 생성
 * 2. source에서 PACK_STGTAB_SQLSET으로 STS 정보를 staging table에 채워 넣기
 * 3. data pump를 통해 source에서 target으로 staging table 이관 
 * 4. target에서 UNPACK_STGTAB_SQLSET으로 staging table의 정보를 STS로 이동
 */
BEGIN
  DBMS_SQLTUNE.CREATE_STGTAB_SQLSET ( 
    table_name  => 'my_11g_staging_table'
,   schema_name => 'SCOTT'
,   db_version  => DBMS_SQLTUNE.STS_STGTAB_11_2_VERSION 
);
END;
/

BEGIN
  DBMS_SQLTUNE.PACK_STGTAB_SQLSET (      
    sqlset_name         => 'SQLT_WKLD_STS_TEST'
,   sqlset_owner        => 'SCOTT'
,   staging_table_name  => 'my_11g_staging_table'
,   staging_schema_owner => 'SCOTT'
,   db_version          => DBMS_SQLTUNE.STS_STGTAB_11_2_VERSION 
);
END;
/ 

SELECT * FROM SCOTT.MY_11G_STAGING_TABLE mgst ;
--DROP TABLE SCOTT.MY_11G_STAGING_TABLE PURGE;

BEGIN
  DBMS_SQLTUNE.DELETE_SQLSET (
      sqlset_name  => 'SQLT_WKLD_STS_TEST'
);
END;
/

SELECT * FROM TABLE( DBMS_SQLTUNE.SELECT_SQLSET( 'SQLT_WKLD_STS_TEST' ) );

BEGIN
  DBMS_SQLTUNE.UNPACK_STGTAB_SQLSET (
    sqlset_name        => '%'
,   replace            => true
,   staging_table_name => 'my_11g_staging_table');
END;
/

SELECT * FROM TABLE( DBMS_SQLTUNE.SELECT_SQLSET( 'SQLT_WKLD_STS_TEST' ) );