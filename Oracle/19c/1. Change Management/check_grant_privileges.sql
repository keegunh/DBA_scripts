/*
* 용도       : PNP정산시스템 DB 권한검증 및 권한부여
* 수행DB     : DNUPB, TNUPB, PNUPB
* 마지막수정일자 : 2021.11.04
*
* PMPBDBA.HKG_TABLE_INFO에 테이블정보 입력 필요:
* 1. PMPBDBA.HKG_TABLE_INFO 테이블 정보는 "생성테이블정리_MASTER.xlsx" 파일에서 관리.
* 2. 상기 엑셀파일 첫번째 시트에서 INSERT문 추출하여 HKG_TABLE_INFO에 INSERT.
* 3. 하기 검증 쿼리 사용.
*/

-- ################ 권한검증 & 권한부여 ################
-- 부여되지 않은 테이블 권한 확인
SELECT D.*
     , 'GRANT ' || D.PRIVILEGE || ' ON ' || D.OWNER || '.' || D.TABLE_NAME || ' TO ' || D.GRANTEE ||';' AS GRANT_DDL
  FROM (
        SELECT -- 있어야 할 테이블 권한
               C.OWNER  
             , C.TABLE_NAME
             , C.GRANTEE
             , C.PRIVILEGE
          FROM (
                SELECT A.OWNER
                     , A.TABLE_NAME
                     , B.ROLE AS GRANTEE
                     , B.PRIVILEGE
                  FROM PMPBDBA.HKG_TABLE_INFO A
                     , PMPBDBA.HKG_MODULE_ROLE_PRIVS B
                 WHERE A.MODULE = B.MODULE
                 UNION ALL
                SELECT A.OWNER
                     , A.TABLE_NAME
                     , B.ROLE AS GRANTEE
                     , B.PRIVILEGE
                  FROM (SELECT * FROM PMPBDBA.HKG_TABLE_INFO WHERE EAI_YN = 'Y') A
                     , (SELECT * FROM PMPBDBA.HKG_MODULE_ROLE_PRIVS B WHERE MODULE = 'EAI') B
                ) C
         MINUS
        SELECT -- 현재 DB에 존재하는 권한
               UNISTR(A.OWNER) OWNER 
             , UNISTR(A.TABLE_NAME) TABLE_NAME
             , UNISTR(A.GRANTEE) GRANTEE
             , UNISTR(A.PRIVILEGE) PRIVILEGE
          FROM DBA_TAB_PRIVS A
         WHERE A.OWNER = 'PMPBADM'
           AND A.GRANTEE < > 'PMPBMIG'
) D
;

-- 회수해야할 테이블 권한 확인
SELECT D.*
     , 'REVOKE ' || D.PRIVILEGE || ' ON ' || D.OWNER || '.' || D.TABLE_NAME || ' FROM ' || D.GRANTEE ||';' AS REVOKE_DDL
  FROM (
        SELECT -- 현재 DB에 존재하는 테이블 권한
               UNISTR(A.OWNER) OWNER
             , UNISTR(A.TABLE_NAME) TABLE_NAME
             , UNISTR(A.GRANTEE) GRANTEE
             , UNISTR(A.PRIVILEGE) PRIVILEGE
          FROM DBA_TAB_PRIVS A, DBA_TABLES B
         WHERE A.OWNER = B.OWNER
           AND A.TABLE_NAME = B.TABLE_NAME
           AND A.OWNER = 'PMPBADM'
           AND A.GRANTEE < > 'PMPBMIG'
        MINUS 
        SELECT -- 있어야 할 테이블 권한
               C.OWNER  
             , C.TABLE_NAME
             , C.GRANTEE
             , C.PRIVILEGE
          FROM (
                SELECT A.OWNER
                     , A.TABLE_NAME
                     , B.ROLE AS GRANTEE
                     , B.PRIVILEGE
                  FROM PMPBDBA.HKG_TABLE_INFO A
                     , PMPBDBA.HKG_MODULE_ROLE_PRIVS B
                 WHERE A.MODULE = B.MODULE
                 UNION ALL
                SELECT A.OWNER
                     , A.TABLE_NAME
                     , B.ROLE AS GRANTEE
                     , B.PRIVILEGE
                  FROM (SELECT * FROM PMPBDBA.HKG_TABLE_INFO WHERE EAI_YN = 'Y') A
                     , (SELECT * FROM PMPBDBA.HKG_MODULE_ROLE_PRIVS B WHERE MODULE = 'EAI') B
        ) C
) D
;

-- 테이블 이외 오브젝트 권한 부여
SELECT OBJECT_TYPE, OWNER, OBJECT_NAME
     , CASE 
         WHEN OBJECT_TYPE IN ('TABLE', 'TABLE PARTITION', 'TABLE SUBPARTITION') THEN 
           'GRANT SELECT,INSERT,UPDATE,DELETE ON PMPBADM.' || OBJECT_NAME || ' TO RL_PMPB_ALL;' || CHR(13) || 
           'GRANT SELECT ON PMPBADM.' || OBJECT_NAME || ' TO RL_PMPB_SEL;'
         WHEN OBJECT_TYPE IN ('VIEW', 'SEQUENCE') THEN
           'GRANT SELECT ON PMPBADM.' || OBJECT_NAME || ' TO RL_PMPB_SEL, RL_PMPB_ALL;'
         WHEN OBJECT_TYPE IN ('FUNCTION', 'PROCEDURE') THEN
           'GRANT EXECUTE ON PMPBADM.' || OBJECT_NAME || ' TO PMPBAPP, PMPBBAT, PMPBDEV;'
         ELSE NULL
       END AS GRANT_DDL
  FROM DBA_OBJECTS
 WHERE OWNER = 'PMPBADM'
   AND OBJECT_TYPE NOT IN ('INDEX', 'INDEX PARTITION', 'INDEX SUBPARTITION', 'LOB', 'TYPE', 'DATABASE LINK', 'TRIGGER', 'TABLE', 'SYNONYM')
   AND OBJECT_NAME NOT IN (SELECT TABLE_NAME FROM DBA_TAB_PRIVS)
 ORDER BY 1,2,3;








-- ################ 아래는 참고 쿼리 ################
-- 권한부여1
SELECT T.OWNER
     , T.TABLE_NAME
     , T.MODULE
     , T.GRANTEE
     , T.PRIVILEGE
     , T.GRANT_DDL
  FROM (
        SELECT A.OWNER
             , A.TABLE_NAME
             , B.MODULE
             , B.ROLE AS GRANTEE
             , B.PRIVILEGE
             , 'GRANT ' || B.PRIVILEGE || ' TO ' || A.OWNER || '.' || A.TABLE_NAME || ';' AS GRANT_DDL
          FROM PMPBDBA.HKG_TABLE_INFO A
             , PMPBDBA.HKG_MODULE_ROLE_PRIVS B
         WHERE A.MODULE = B.MODULE
         UNION ALL
        SELECT A.OWNER
             , A.TABLE_NAME
             , B.MODULE
             , B.ROLE AS GRANTEE
             , B.PRIVILEGE
             , 'GRANT ' || B.PRIVILEGE || ' TO ' || A.OWNER || '.' || A.TABLE_NAME || ';' AS GRANT_DDL
          FROM (SELECT * FROM PMPBDBA.HKG_TABLE_INFO WHERE EAI_YN = 'Y') A
             , (SELECT * FROM PMPBDBA.HKG_MODULE_ROLE_PRIVS B WHERE MODULE = 'EAI') B
) T
-- WHERE T.TABLE_NAME LIKE '%테이블명%'
ORDER BY T.OWNER, T.TABLE_NAME, T.GRANTEE;
;

-- 권한부여2
SELECT OWNER
     , TABLE_NAME
     , TABLESPACE_NAME
     , TABLE_COMMENT
     , PARTITIONING_TYPE
     , PART_KEY
     , MIN_PART
     , MAX_PART
     , SUBPARTITIONING_TYPE
     , SUBPARTITION_COUNT
     , MODULE
     , MODEL_TABLE_NAME
     , REMARKS
     , EAI_YN
     , CASE WHEN MODULE = '01_정산슬림화인터페이스_SET'
            THEN 'GRANT SELECT, INSERT, UPDATE, DELETE ON PMPBADM.' || TABLE_NAME || ' TO RL_EVNT_ALL;' || CHR(13) || CHR(10) ||
                 'GRANT SELECT ON PMPBADM.' || TABLE_NAME || ' TO RL_EVNT_SEL;' || CHR(13) || CHR(10) ||
                 'GRANT SELECT ON PMPBADM.' || TABLE_NAME || ' TO RL_PMPB_SEL;'
            WHEN MODULE IN ( '01_공통정보_SET'
                           , '01_MVNO정산_SET'
                           , '01_기준정보_SET'
                           , '01_로밍정산_SET'
                           , '01_무선접속료정산_SET'
                           , '01_발신변작방지_SET'
                           , '01_일반정산_SET'
                           , '01_임차정산_SET'
                           , '02_VOD정산_SET'
                           , '02_유선국제정산_SET'
                           , '02_유선접속료정산_SET'
                           , '03_유선국내정산_SET'
                           , '02_정산가상단인터페이스_SET')
            THEN 'GRANT SELECT, INSERT, UPDATE, DELETE ON PMPBADM.' || TABLE_NAME || ' TO RL_PMPB_ALL;' || CHR(13) || CHR(10) ||
                 'GRANT SELECT ON PMPBADM.' || TABLE_NAME || ' TO RL_PMPB_SEL;'
       END AS GRANT_DDL
     , CASE WHEN EAI_YN = 'Y' THEN 'GRANT SELECT, INSERT, UPDATE, DELETE ON PMPBADM.' || TABLE_NAME || ' TO RL_PMPB_EAI;' ELSE NULL END AS GRANT_DDL_EAI
  FROM PMPBDBA.HKG_TABLE_INFO
 WHERE 1=1
   -- AND TABLE_NAME LIKE '%테이블명%'
;






update HKG_TABLE_INFO set owner = 'BLCP01ADM' where tablespace_name = 'TS_BLCP_DP01';
update HKG_TABLE_INFO set owner = 'BLCP02ADM' where tablespace_name = 'TS_BLCP_DP02';
update HKG_TABLE_INFO set owner = 'BLCP03ADM' where tablespace_name = 'TS_BLCP_DP03';
update HKG_TABLE_INFO set owner = 'BLCP04ADM' where tablespace_name = 'TS_BLCP_DP04';
update HKG_TABLE_INFO set owner = 'BLCP05ADM' where tablespace_name = 'TS_BLCP_DP05';
update HKG_TABLE_INFO set owner = 'BLCP06ADM' where tablespace_name = 'TS_BLCP_DP06';
update HKG_TABLE_INFO set owner = 'BLCP07ADM' where tablespace_name = 'TS_BLCP_DP07';
update HKG_TABLE_INFO set owner = 'BLCP08ADM' where tablespace_name = 'TS_BLCP_DP08';
update HKG_TABLE_INFO set owner = 'BLCP09ADM' where tablespace_name = 'TS_BLCP_DP09';
update HKG_TABLE_INFO set owner = 'BLCP10ADM' where tablespace_name = 'TS_BLCP_DP10';
COMMIT;