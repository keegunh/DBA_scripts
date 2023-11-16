SELECT dba
     , datname
	 , size
	 , buffers
	 , buffers * 8192 AS buffer_size
	 , case when buffers = 0 then 0 else round(buffers::numeric*8192/size::numeric*100,2) end AS "Cache %"
  FROM (SELECT pg_get_userbyid(datdba) AS dba
             , datname
             , pg_database_size(reldatabase) AS size
             , count(*) AS buffers
          FROM pg_buffercache
             , pg_database
         WHERE reldatabase=pg_database.oid
         GROUP BY 1, 2, 3)
 ORDER BY 1, 2, 3;