TTITLE "[DBname] Database|Oracle Backup Status"

SET LINESIZE 250
SET PAGESIZE 1000
SET HEADING ON

COL TS_NAME FORMAT A15
COL FILE# FORMAT 99999
COL FILE_NAME FORMAT A50
COL GB FORMAT 99
COL DATAFILE_STAT FORMAT A14
COL AUTOEXTENSIBLE FORMAT A3
COL BACKUP_STAT FORMAT A12
COL CHANGE# FORMAT 999999
COL BACKUP_START_TIME FORMAT A19

SELECT A.TABLESPACE_NAME TS_NAME
     , B.FILE#
     , A.FILE_NAME
     , A.BYTES/1024/1024/1024 GB
     , A.STATUS DATAFILE_STAT
     , A.AUTOEXTENSIBLE
     , B.STATUS BACKUP_STAT
     , B.CHANGE#
     , TO_CHAR(B.TIME, 'YYYY/MM/DD HH24:MM:SS') AS BACKUP_START_TIME
  FROM DBA_DATA_FILES A
     , V$BACKUP B
 WHERE A.FILE_ID = B.FILE#
 ORDER BY A.TABLESPACE_NAME, B.FILE# ;
 
TTITLE OFF