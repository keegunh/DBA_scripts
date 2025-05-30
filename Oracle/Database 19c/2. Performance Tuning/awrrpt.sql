-- Automatic Workload Repository
-- 가장 많이 알려진 오라클 성능 보고서
-- 튜닝 전문가들은 AWR 리포트로 주로 분석을 시작

-- 방법 1. 서버 디렉토리에 리포트 파일 생성 - SQLPLUS로 실행
@?/rdbms/admin/awrrpt.sql


-- 방법 2-1. 쿼리 결과로 리포트 생성 - DBID, INSTANCE_NUMBER, SNAP_ID 확인
SELECT DBID
     , INSTANCE_NUMBER
	 , MIN(SNAP_ID) AS START_SNAP_ID
	 , MAX(SNAP_ID) AS END_SNAP_ID
  FROM DBA_HIST_SNAPSHOT
 WHERE BEGIN_INTERVAL_TIME BETWEEN TO_DATE('202312210900', 'YYYYMMDDHH24MISS')
   AND TO_DATE('202312220900', 'YYYYMMDDHH24MISS')
 GROUP BY DBID, INSTANCE_NUMBER
 ORDER BY DBID, INSTANCE_NUMBER
;

-- 방법 2-2. 쿼리 결과로 리포트 생성 - AWR REPORT HTML로 생성
SELECT OUTPUT FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(:dbid, :instance_number, :start_snap_id, :end_snap_id));
SELECT OUTPUT FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(2271455618, 1, 1502, 1525));

-- 방법 2-2. 쿼리 결과로 리포트 생성 - AWR REPORT TEXT로 생성
SELECT OUTPUT FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_TEXT(:dbid, :instance_number, :start_snap_id, :end_snap_id));
SELECT OUTPUT FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_TEXT(2271455618, 1, 1502, 1525));


-- AWR Snapshot 간격 및 보관기간 확인
SELECT SNAP_INTERVAL, RETENTION FROM DBA_HIST_WR_CONTROL;