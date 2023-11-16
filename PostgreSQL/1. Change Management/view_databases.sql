SELECT datname
     , pg_get_userbyid(datdba) AS dba
	 , pg_catalog.pg_encoding_to_char(encoding) AS encoding
	 , datcollate
	 , datctype
	 , datistemplate
	 , datallowconn
	 , datconnlimit
	 , datlastsysoid
	 , datfrozenxid
	 , spcname as tablespace
	 , pg_size_pretty(pg_database_size(datname)) AS size
	 , datacl
	 , age(datfrozenxid) AS freezeage
	 , ROUND(100*(age(datfrozenxid)/freez::float)) AS perc
  FROM pg_database
     , pg_tablespace
  JOIN (SELECT setting AS freez
          FROM pg_settings
         WHERE name = 'autovacuum_freeze_max_age') AS param
    ON (true)
 WHERE dattablespace = pg_tablespace.oid ORDER BY datname;