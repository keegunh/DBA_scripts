SELECT relname
     , nspname AS schema
     , pg_get_userbyid(relowner) AS owner
     , relam
     , relfilenode
     , (select spcname from pg_tablespace where oid=reltablespace) as tablespace
     , relpages
     , reltuples
     , reltoastrelid
     , relhasindex
     , relisshared
     , relkind
     , relnatts
     , relchecks
     , CASE WHEN relpersistence='t' THEN 'Temporary'
            ELSE 'Unknown'
       END AS relpersistence
     , relhasoids
     , relhaspkey
     , relhasrules
     , relhassubclass
     , relfrozenxid
     , relacl
     , reloptions
     , pg_size_pretty(pg_relation_size(pg_class.oid)) AS size
  FROM pg_class
     , pg_namespace
 WHERE relkind = 'S'
   AND relnamespace = pg_namespace.oid
 ORDER BY relname;

SELECT 'sys' AS schema
     , sequence_name
     , last_value
     , start_value
     , increment_by
     , max_value
     , min_value
     , cache_value
     , log_cnt
     , is_cycled
     , is_called
  FROM "sys"."plsql_profiler_runid"
 UNION
SELECT 'sys' AS schema
     , sequence_name
     , last_value
     , start_value
     , increment_by
     , max_value
     , min_value
     , cache_value
     , log_cnt
     , is_cycled
     , is_called
  FROM "sys"."snapshot_num_seq"
 ORDER BY sequence_name;