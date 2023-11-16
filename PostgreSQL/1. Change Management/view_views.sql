SELECT relname
     , nspname AS schema
     , pg_get_userbyid(relowner) AS owner
     , relam
     , relfilenode
     , (select spcname
          from pg_tablespace
         where oid=reltablespace) as tablespace
     , relpages
     , reltuples
     , reltoastrelid
     , relhasindex
     , relisshared
     , relkind
     , relnatts
     , relchecks
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
 WHERE relkind = 'v'
   AND relnamespace = pg_namespace.oid
 ORDER BY relname;