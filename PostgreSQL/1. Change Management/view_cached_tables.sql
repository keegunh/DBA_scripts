-- pg_buffercache extension 미설치 시 root에서 yum install postgresql14-contrib -y 수행 후 psql에서 아래 명령어 수행
-- CREATE EXTENSION pg_buffercache;

SELECT nspname
     , relname
     , size
     , buffers
     , buffers * 8192 AS buffer_size
     , case when buffers = 0 then 0
            else round(buffers::numeric*8192/size::numeric*100,2)
       end AS "Cache %"
  FROM (SELECT n.nspname
             , c.relname
             , pg_relation_size(c.oid) AS size
             , count(*) AS buffers
          FROM pg_buffercache b
             , pg_class c
             , pg_namespace n 
         WHERE b.relfilenode = c.relfilenode
           AND c.relnamespace = n.oid
           AND c.relkind = 'r'
           AND b.reldatabase IN (0, (SELECT oid
                                       FROM pg_database
                                      WHERE datname = current_database()))
         GROUP BY n.nspname, c.relname, size) as bc
 ORDER BY 3 DESC;