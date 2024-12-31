-- view all locks
SELECT locktype
     , CASE WHEN datname IS NOT NULL THEN datname
            ELSE database::text
       END AS database
     , nspname
     , relname
     , page
     , tuple
     , virtualxid
     , transactionid
     , classid
     , objid
     , objsubid
     , virtualtransaction
     , pid
     , mode
     , fastpath
     , granted
  FROM pg_locks
  LEFT JOIN pg_database
    ON pg_database.oid = database
  LEFT JOIN pg_class
    ON pg_class.oid = relation
  LEFT JOIN pg_namespace
    ON pg_namespace.oid=pg_class.relnamespace;


-- view exclusive locks
SELECT locktype
     , CASE WHEN datname IS NOT NULL THEN datname ELSE database::text END AS database
     , nspname
     , relname
     , page
     , tuple
     , virtualxid
     , transactionid
     , classid
     , objid
     , objsubid
     , virtualtransaction
     , pid
     , granted
  FROM pg_locks
  LEFT JOIN pg_database
    ON pg_database.oid = database
  LEFT JOIN pg_class
    ON pg_class.oid = relation
  LEFT JOIN pg_namespace
    ON pg_namespace.oid=pg_class.relnamespace
 WHERE mode='ExclusiveLock'
   AND locktype NOT IN ('virtualxid', 'transactionid');
   
-- Viewing locks with table names and queries
select 
    relname as relation_name, 
    query, 
    pg_locks.* 
from pg_locks
join pg_class on pg_locks.relation = pg_class.oid
join pg_stat_activity on pg_locks.pid = pg_stat_activity.pid;
