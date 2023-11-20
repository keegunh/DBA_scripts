SET PAGESIZE 500
SET LINESIZE 200
COL NAME FORMAT A20
COL VALUE FORMAT A20
COL DEFAULT_VALUE FORMAT A20
COL ISDEFAULT FORMAT A9
COL DESCRIPTION FORMAT A80

SELECT NAME
     , VALUE
     , DEFAULT_VALUE
     , ISDEFAULT
     , DESCRIPTION
  FROM V$PARAMETER
 WHERE NAME IN ('db_cache_advice'
             , 'db_cache_size'
             , 'java_pool_size'
             , 'large_pool_size'
             , 'memory_target'
             , 'pga_aggregate_target'
             , 'sga_target'
             , 'shared_pool_size'
             , 'streams_pool_size');