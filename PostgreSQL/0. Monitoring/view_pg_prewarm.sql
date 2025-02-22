
Pg_prewarm Extension

The pg_prewarm module provides a convenient way to load relation data into PostgreSQL buffer cache.  
Prewarming can be performed manually using the pg_prewarm function, 
or can be performed automatically by including pg_prewarm in shared_preload_libraries. 

In case of auto prewarm, system will run a background worker which periodically records 
the contents of shared buffers in a file called autoprewarm.
blocks and will be using 2 background workers, reload those same blocks after a restart.

Prerequisites:
Contrib module needs to be installed in Linux for pg_prewarm extension.

Manual Prewarm:
1)	 CREATE EXTENSION pg_prewarm;

2)	 Check how many blocks of table available in pg_buffercache.
SELECT count(*)
FROM pg_buffercache
WHERE relfilenode = pg_relation_filenode('labs'::regclass);

3)	Check the tables in buffer cache.
SELECT c.relname,
  count(*) blocks,
  round( 100.0 * 8192 * count(*) / pg_table_size(c.oid) ) "% of rel",
  round( 100.0 * 8192 * count(*) FILTER (WHERE b.usagecount > 3) / pg_table_size(c.oid) ) "% hot"
FROM pg_buffercache b
  JOIN pg_class c ON pg_relation_filenode(c.oid) = b.relfilenode
WHERE  b.reldatabase IN (
         0, (SELECT oid FROM pg_database WHERE datname = current_database())
       )
AND    b.usagecount is not null
GROUP BY c.relname, c.oid
ORDER BY 2 DESC
LIMIT 10;

4)	Number of pages used by table.
SELECT oid::regclass AS tbl, relpages
FROM   pg_class
WHERE  relname = 'labs'; -- table to check

5)	Call Pg_prewarm extension and load the table.
SELECT * FROM pg_prewarm('labs');

6)	Check the table is in memory:
SELECT c.relname,
  count(*) blocks,
  round( 100.0 * 8192 * count(*) / pg_table_size(c.oid) ) "% of rel",
  round( 100.0 * 8192 * count(*) FILTER (WHERE b.usagecount > 3) / pg_table_size(c.oid) ) "% hot"
FROM pg_buffercache b
  JOIN pg_class c ON pg_relation_filenode(c.oid) = b.relfilenode
WHERE  b.reldatabase IN (
         0, (SELECT oid FROM pg_database WHERE datname = current_database())
       )
AND    b.usagecount is not null
GROUP BY c.relname, c.oid
ORDER BY 2 DESC
LIMIT 10;

7)	Restart postgresql.

8)	Check the table is in memory: (The table wont be their in memory)
SELECT c.relname,
  count(*) blocks,
  round( 100.0 * 8192 * count(*) / pg_table_size(c.oid) ) "% of rel",
  round( 100.0 * 8192 * count(*) FILTER (WHERE b.usagecount > 3) / pg_table_size(c.oid) ) "% hot"
FROM pg_buffercache b
  JOIN pg_class c ON pg_relation_filenode(c.oid) = b.relfilenode
WHERE  b.reldatabase IN (
         0, (SELECT oid FROM pg_database WHERE datname = current_database())
       )
AND    b.usagecount is not null
GROUP BY c.relname, c.oid
ORDER BY 2 DESC
LIMIT 10;


   Auto Prewarm:
1)	CREATE EXTENSION pg_prewarm;
2)	ALTER SYSTEM SET shared_preload_libraries = 'pg_prewarm';
3)	Check how many blocks of table available in pg_buffercache.
SELECT count(*)
FROM pg_buffercache
WHERE relfilenode = pg_relation_filenode('labs'::regclass);

4)	Check the table is present in buffer cache.
SELECT c.relname,
  count(*) blocks,
  round( 100.0 * 8192 * count(*) / pg_table_size(c.oid) ) "% of rel",
  round( 100.0 * 8192 * count(*) FILTER (WHERE b.usagecount > 3) / pg_table_size(c.oid) ) "% hot"
FROM pg_buffercache b
  JOIN pg_class c ON pg_relation_filenode(c.oid) = b.relfilenode
WHERE  b.reldatabase IN (
         0, (SELECT oid FROM pg_database WHERE datname = current_database())
       )
AND    b.usagecount is not null
GROUP BY c.relname, c.oid
ORDER BY 2 DESC
LIMIT 10;

5)	Number of pages used by table.
SELECT oid::regclass AS tbl, relpages
FROM   pg_class
WHERE  relname = 'labs';

9)	Call Pg_prewarm extension and load the table.
SELECT * FROM pg_prewarm('labs');

10)	Check the table is in memory:
SELECT c.relname,
  count(*) blocks,
  round( 100.0 * 8192 * count(*) / pg_table_size(c.oid) ) "% of rel",
  round( 100.0 * 8192 * count(*) FILTER (WHERE b.usagecount > 3) / pg_table_size(c.oid) ) "% hot"
FROM pg_buffercache b
  JOIN pg_class c ON pg_relation_filenode(c.oid) = b.relfilenode
WHERE  b.reldatabase IN (
         0, (SELECT oid FROM pg_database WHERE datname = current_database())
       )
AND    b.usagecount is not null
GROUP BY c.relname, c.oid
ORDER BY 2 DESC
LIMIT 10;

11)	Restart postgresql.

12)	Check the table is in memory: (The table should be in their memory)
SELECT c.relname,
  count(*) blocks,
  round( 100.0 * 8192 * count(*) / pg_table_size(c.oid) ) "% of rel",
  round( 100.0 * 8192 * count(*) FILTER (WHERE b.usagecount > 3) / pg_table_size(c.oid) ) "% hot"
FROM pg_buffercache b
  JOIN pg_class c ON pg_relation_filenode(c.oid) = b.relfilenode
WHERE  b.reldatabase IN (
         0, (SELECT oid FROM pg_database WHERE datname = current_database())
       )
AND    b.usagecount is not null
GROUP BY c.relname, c.oid
ORDER BY 2 DESC
LIMIT 10;
13)	If you want to know how much percentage of the buffer the table is using:
SELECT
  c.relname,
  pg_size_pretty(count(*) * 8192) as buffered,
  round(100.0 * count(*) / 
    (SELECT setting FROM pg_settings
      WHERE name='shared_buffers')::integer,1)
    AS buffers_percent,
  round(100.0 * count(*) * 8192 / 
    pg_table_size(c.oid),1)
    AS percent_of_relation
FROM pg_class c
  INNER JOIN pg_buffercache b
    ON b.relfilenode = c.relfilenode
  INNER JOIN pg_database d
    ON (b.reldatabase = d.oid AND d.datname = current_database())
GROUP BY c.oid,c.relname
ORDER BY 3 DESC LIMIT 10;



ALTER SYSTEM RESET shared_preload_libraries;
DROP EXTENSION pg_prewarm;