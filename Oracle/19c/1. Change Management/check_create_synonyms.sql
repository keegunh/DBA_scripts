/*
* 용도       : PNP정산시스템 DB 동의어 생성 및 제거
* 수행DB     : DNUPB, TNUPB, PNUPB
* 마지막수정일자 : 2021.11.04
*/

-- ################ 기타 확인 사항 ################
-- *** 인덱스, NOT NULL, DEFAULT, PK 순서는 ASIS 운영과 비교해야함.

-- ################ 동의어 생성 ################
-- 생성되지 않은 SYNONYMS 생성
SELECT OBJECT_TYPE, OWNER, OBJECT_NAME
     , 'CREATE OR REPLACE SYNONYM PMPBAPP.' || OBJECT_NAME || ' FOR PMPBADM.' || OBJECT_NAME || ';' AS SYNONYM_DDL
  FROM DBA_OBJECTS
 WHERE OWNER = 'PMPBADM'
   AND OBJECT_TYPE NOT IN ('INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION', 'LOB', 'TYPE', 'DATABASE LINK')
   AND OBJECT_NAME NOT IN (SELECT SYNONYM_NAME FROM DBA_SYNONYMS WHERE OWNER = 'PMPBAPP')
 UNION 
SELECT OBJECT_TYPE, OWNER, OBJECT_NAME
     , 'CREATE OR REPLACE SYNONYM PMPBBAT.' || OBJECT_NAME || ' FOR PMPBADM.' || OBJECT_NAME || ';' AS SYNONYM_DDL
  FROM DBA_OBJECTS
 WHERE OWNER = 'PMPBADM'
   AND OBJECT_TYPE NOT IN ('INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION', 'LOB', 'TYPE', 'DATABASE LINK')
   AND OBJECT_NAME NOT IN (SELECT SYNONYM_NAME FROM DBA_SYNONYMS WHERE OWNER = 'PMPBBAT')
 UNION 
SELECT OBJECT_TYPE, OWNER, OBJECT_NAME
     , 'CREATE OR REPLACE SYNONYM PMPBMIG.' || OBJECT_NAME || ' FOR PMPBADM.' || OBJECT_NAME || ';' AS SYNONYM_DDL
  FROM DBA_OBJECTS
 WHERE OWNER = 'PMPBADM'
   AND OBJECT_TYPE NOT IN ('INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION', 'LOB', 'TYPE', 'DATABASE LINK')
   AND OBJECT_NAME NOT IN (SELECT SYNONYM_NAME FROM DBA_SYNONYMS WHERE OWNER = 'PMPBMIG')
 UNION 
SELECT OBJECT_TYPE, OWNER, OBJECT_NAME
     , 'CREATE OR REPLACE SYNONYM PMPBDEV.' || OBJECT_NAME || ' FOR PMPBADM.' || OBJECT_NAME || ';' AS SYNONYM_DDL
  FROM DBA_OBJECTS
 WHERE OWNER = 'PMPBADM'
   AND OBJECT_TYPE NOT IN ('INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION', 'LOB', 'TYPE', 'DATABASE LINK')
   AND OBJECT_NAME NOT IN (SELECT SYNONYM_NAME FROM DBA_SYNONYMS WHERE OWNER = 'PMPBDEV')
 ORDER BY 1,2,3;

-- EAI 테이블 SYNONYM 생성
SELECT OWNER
     , TABLE_NAME
     , 'GRANT SELECT, INSERT, UPDATE, DELETE ON ' || OWNER || '.' || TABLE_NAME || ' TO RL_PMPB_EAI;' AS GRANT_DDL
     , 'CREATE OR REPLACE SYNONYM PMPBEAI.' || TABLE_NAME || ' FOR ' || OWNER || '.' || TABLE_NAME || ';' AS SYNONYM_DDL
  FROM PMPBDBA.HKG_TABLE_INFO
 WHERE EAI_YN = 'Y';
 
-- ################ 미사용 동의어 제거 ################ 
-- 미사용 SYNONYMS 제거
SELECT OWNER
     , SYNONYM_NAME
     , TABLE_OWNER
     , TABLE_NAME
     , DB_LINK
     , ORIGIN_CON_ID
     , 'DROP SYNONYM ' || OWNER || '.' || SYNONYM_NAME || ';' AS DROP_DDL
  FROM DBA_SYNONYMS
 WHERE SYNONYM_NAME IN (
        SELECT SYNONYM_NAME
          FROM DBA_SYNONYMS
         WHERE TABLE_OWNER = 'PMPBADM'
         MINUS
        SELECT OBJECT_NAME
          FROM DBA_OBJECTS
         WHERE OWNER = 'PMPBADM' )
 ORDER BY 1,2;