TTITLE "[DBName] Database|Oracle Tables"

SET PAGESIZE 1000
SET LINESIZE 250
SET HEADING ON
COL OWNER FORMAT A10
COL TABLE_NAME FORMAT A35
COL TS_NAME FORMAT A15
COL COMMENTS FORMAT A60
COL PART_TYPE FORMAT A15
COL PART_KEY FORMAT A20
COL MIN_PART FORMAT A10
COL MAX_PART FORMAT A10
COL SUBPART_TYPE FORMAT A15
COL SUBPART_CNT FORMAT 999
COL STATUS FORMAT A8
COL PCT_FREE FORMAT 999
COL CHAIN_CNT FORMAT 999


SELECT A.OWNER
     , A.TABLE_NAME
     , NVL(A.TABLESPACE_NAME, B.DEF_TABLESPACE_NAME) AS TS_NAME
     , C.COMMENTS
     , B.PARTITIONING_TYPE AS PART_TYPE
     , E.PART_KEY
     , MIN(D.PARTITION_NAME) AS MIN_PART
     , MAX(D.PARTITION_NAME) AS MAX_PART
     , B.SUBPARTITIONING_TYPE AS SUBPART_TYPE
     , MAX(D.SUBPARTITION_COUNT) AS SUBPART_CNT
	 , A.STATUS
--     , NVL(A.PCT_FREE, B.DEF_PCT_FREE) AS PCT_FREE
--	 , A.CHAIN_CNT
  FROM DBA_TABLES A
     , DBA_PART_TABLES B
     , DBA_TAB_COMMENTS C
     , DBA_TAB_PARTITIONS D
     , (SELECT OWNER
             , NAME
             , LISTAGG(COLUMN_NAME, ',') WITHIN GROUP (ORDER BY COLUMN_POSITION) AS PART_KEY
          FROM DBA_PART_KEY_COLUMNS
         WHERE OWNER NOT IN ('SYS'
                      , 'SYSTEM'
                      , 'OUTLN'
                      , 'XS$NULL'
                      , 'OJVMSYS'
                      , 'GGSYS'
                      , 'ANONYMOUS'
                      , 'DBSNMP'
                      , 'GSMADMIN_INTERNAL'
                      , 'XDB'
                      , 'WMSYS'
                      , 'CTXSYS'
                      , 'DBSFWUSER'
                      , 'APPQOSSYS'
                      , 'GSMUSER'
                      , 'SYSDG'
                      , 'SYSKM'
                      , 'ORACLE_OCM'
                      , 'GSMCATUSER'
                      , 'REMOTE_SCHEDULER_AGENT'
                      , 'SYS$UMF'
                      , 'SYSBACKUP'
                      , 'SYSRAC'
                      , 'DIP'
                      , 'AUDSYS'
					  , 'DVSYS'
					  , 'LBACSYS'
					  , 'MDSYS')
           AND OBJECT_TYPE = 'TABLE'
         GROUP BY OWNER, NAME) E
 WHERE A.OWNER = B.OWNER (+)
   AND A.TABLE_NAME = B.TABLE_NAME (+)
   AND A.OWNER = C.OWNER (+)
   AND A.TABLE_NAME = C.TABLE_NAME (+)
   AND A.OWNER = D.TABLE_OWNER (+)
   AND A.TABLE_NAME = D.TABLE_NAME (+)
   AND A.OWNER = E.OWNER (+)
   AND A.TABLE_NAME = E.NAME (+)
   AND A.OWNER NOT IN ('SYS'
                , 'SYSTEM'
                , 'OUTLN'
                , 'XS$NULL'
                , 'OJVMSYS'
                , 'GGSYS'
                , 'ANONYMOUS'
                , 'DBSNMP'
                , 'GSMADMIN_INTERNAL'
                , 'XDB'
                , 'WMSYS'
                , 'CTXSYS'
                , 'DBSFWUSER'
                , 'APPQOSSYS'
                , 'GSMUSER'
                , 'SYSDG'
                , 'SYSKM'
                , 'ORACLE_OCM'
                , 'GSMCATUSER'
                , 'REMOTE_SCHEDULER_AGENT'
                , 'SYS$UMF'
                , 'SYSBACKUP'
                , 'SYSRAC'
                , 'DIP'
                , 'AUDSYS'
			    , 'DVSYS'
			    , 'LBACSYS'
			    , 'MDSYS')
 GROUP BY A.OWNER, A.TABLE_NAME, A.TABLESPACE_NAME, B.DEF_TABLESPACE_NAME, C.COMMENTS, B.PARTITIONING_TYPE, E.PART_KEY, B.SUBPARTITIONING_TYPE, A.STATUS, A.PCT_FREE, B.DEF_PCT_FREE, A.CHAIN_CNT
 ORDER BY A.OWNER,A.TABLE_NAME
;

TTITLE OFF