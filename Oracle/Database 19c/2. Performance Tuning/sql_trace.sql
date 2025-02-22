
-- sqlplus sqltrace tkprof
ALTER SESSION SET SQL_TRACE = TRUE;
--EXEC DBMS_SESSION.SET_SQL_TRACE(TRUE);
--ALTER SESSION SET TRACEFILE_IDENTIFIER = 'FLAG';
ALTER SESSION SET EVENTS '10046 TRACE NAME CONTEXT FOREVER, LEVEL 8';
SELECT * FROM...; -- QUERY
--EXEC DBMS_SESSION.SET_SQL_TRACE(FALSE);
ALTER SESSION SET SQL_TRACE = FALSE;
ALTER SESSION SET EVENTS '10046 TRACE NAME CONTEXT OFF';


--SHOW PARAMETER diagnostic test 이 경로 아래에서 더 찾아야 함
--cd /oralog/[DBNAME]/diag/rdbms/[DBNAME]/[DBNAME]/trace
SELECT R.VALUE || '/' || T.INSTANCE_NAME ||'_ora_' || LTRIM(TO_CHAR(P.SPID)) || '.trc' TRACE_FILE
  FROM V$PROCESS P, V$SESSION S, V$PARAMETER R, V$INSTANCE T
 WHERE P.ADDR = S.PADDR
   AND R.NAME = 'diagnostic_dest'
   AND S.SID = (SELECT SID FROM V$MYSTAT WHERE ROWNUM = 1);


/*
TRACE LEVEL 1 : 기본정보
TRACE LEVEL 4 : 기본정보 + BINDING 정보 출력
TRACE LEVEL 8 : 기본정보 + WAITING 정보 출력
TRACE LEVEL 12 : 기본정보 + BINDIGN + WAITING 정보 출력

## LEVEL 4 이상 설정 시 TRACE FILE이 매우 급격하게 커지므로 주의 필요
*/

tkprof tracefile outputfile [options]

/*
OPTION						설명
SORT=option					명령문 정렬 순서 (ex. execpu:실행에 사용된 cpu시간으로 정렬)
EXPLAIN=username/password	지정된 schema에서 EXPLAIN PLAN을 실행함
SYS=NO						SYS user에 의해 실행된 Recursive SQL문의 나열 비활성화
AGGREGATE=NO				다른 user의 동일한 SQL문을 하나의 레코드로 집계하지 않음
WAITS=YES					Trace 파일에서 발견된 모든 Wait 이벤트에 대한 요약 기록 여부

예시)
tkprof TESTDB_ora_51184396_FLAG.trc PLANTEST SYS=NO
vi PLANTEsT.prf
TKPROF: Release 19.0.0.0 - Development on Fri Oct 13 10:45:05 2023

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

Trace file: TESTDB_ora_51184396_FLAG.trc
Sort options: default

*******************************************************************************
count	= number of times OCI procedure was executed
cpu		= cpu time in seconds executing
elapsed	= elapsed time in seconds executing
disk	= number of physical reads of buffers from disk
query	= number of buffers gotten for consistent read
current	= number of buffers gotten in current mode (usually for update)
rows	= number of rows processed by the fetch or execute call



*******************************************************************************

OVERALL TOTALS FOR ALL NON-RECURSIVE STATEMENTS

call     count	     cpu    elapsed      disk     query   current      rows
------- ------  -------- ---------- --------- --------- --------- ---------
Parse        4      0.00       0.00         0         0         0         0
Execute      4      0.00       0.00         0         0         0         0
Fetch        2      0.00       0.00         0         1         0         1
------- ------  -------- ---------- --------- --------- --------- ---------
total       10      0.00       0.00         0         1         0         1

Misses in library cache during parse: 1

Elapsed times include waiting on following events:
  Event waited on                               Times   Max. Wait  Total Waited
  -------------------------------------------  Waited  ----------  ------------
  Disk file operations I/O                          3        0.00          0.00
  SQL*Net message to client                         4        0.00          0.00
  SQL*NET message from client                       4        0.00          0.00


....