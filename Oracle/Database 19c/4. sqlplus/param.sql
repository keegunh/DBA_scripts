SET PAGESIZE 1000
SET LINESIZE 200
COL TYPE FORMAT A10
COL NAME FORMAT A35
COL VALUE FORMAT A40
COL DEFAULT_VALUE FORMAT A30
COL ISDEFAULT FORMAT A9
COL DESCRIPTION FORMAT A70

-- 공통 파라미터
SELECT 'COMMON' AS "TYPE"
     , NAME
     , VALUE
     , DEFAULT_VALUE
     , ISDEFAULT
     , DESCRIPTION
  FROM V$PARAMETER
 WHERE NAME IN (
  'compatible'
, 'control files'
, 'control_file_record_keep_time'
, 'db_name'
, 'db_block_size'
, 'db_files'
, 'db_file_multiblock_read_count'
, 'deferred_segment_creation'
, 'diagnostic_dest'
, 'job_queue_processes'
, 'local_listener'
, 'open_cursors'
, 'processes'
, 'sessions'
, 'spfile'
, 'result_cache_max_size'
)
 UNION ALL
-- 메모리 파라미터
SELECT 'MEMORY' AS "TYPE"
     , NAME
     , VALUE
     , DEFAULT_VALUE
     , ISDEFAULT
     , DESCRIPTION
  FROM V$PARAMETER
 WHERE NAME IN ( 
  'db_cache_advice'
, 'db_cache_size'
, 'java_pool_size'
, 'large_pool_size'
, 'memory_target'
, 'pga_aggregate_target'
, 'sga_target'
, 'shared_pool_size'
, 'streams_pool_size'
)
 UNION ALL
-- 옵티마이저 파라미터
SELECT 'OPTIMIZER' AS "TYPE"
     , NAME
     , VALUE
     , DEFAULT_VALUE
     , ISDEFAULT
     , DESCRIPTION
  FROM V$PARAMETER
 WHERE NAME IN (
  'optimizer_mode'
, 'optimizer_adaptive_reporting_only'
)
 UNION ALL
-- UNDO 파라미터
SELECT 'UNDO' AS "TYPE"
     , NAME
     , VALUE
     , DEFAULT_VALUE
     , ISDEFAULT
     , DESCRIPTION
  FROM V$PARAMETER
 WHERE NAME IN (
  'undo_management'
, 'undo_tablespace'
, 'undo_retention'
)
 UNION ALL
-- 보안 파라미터
SELECT 'SECURITY' AS "TYPE"
     , NAME
     , VALUE
     , DEFAULT_VALUE
     , ISDEFAULT
     , DESCRIPTION
  FROM V$PARAMETER
 WHERE NAME IN (
  'audit_file_dest'
, 'audit_trail'
, 'remote_login_passwordfile'
)
 UNION ALL
-- 병렬 파라미터
SELECT 'PARALLEL' AS "TYPE"
     , NAME
     , VALUE
     , DEFAULT_VALUE
     , ISDEFAULT
     , DESCRIPTION
  FROM V$PARAMETER
 WHERE NAME IN (
  'parallel_force_local'
)
 UNION ALL
-- 클러스터 파라미터
SELECT 'CLUSTER' AS "TYPE"
     , NAME
     , VALUE
     , DEFAULT_VALUE
     , ISDEFAULT
     , DESCRIPTION
  FROM V$PARAMETER
 WHERE NAME IN (
  'cluster_database'
, 'cluster_database_instance'
, 'instance_name'
, 'instance_number'
, 'thread'
)
 UNION ALL
-- 아카이브 파라미터
SELECT 'ARCHIVE' AS "TYPE"
     , NAME
     , VALUE
     , DEFAULT_VALUE
     , ISDEFAULT
     , DESCRIPTION
  FROM V$PARAMETER
 WHERE NAME IN (
  'log_archive_dest_1'
, 'log_archive_dest_2'
, 'log_archive_format'
)
 UNION ALL
-- 인스턴스 복구 파라미터
SELECT 'RECOVERY' AS "TYPE"
     , NAME
     , VALUE
     , DEFAULT_VALUE
     , ISDEFAULT
     , DESCRIPTION
  FROM V$PARAMETER
 WHERE NAME IN (
  'fast_start_mttr_target'
)
 ORDER BY TYPE, NAME;