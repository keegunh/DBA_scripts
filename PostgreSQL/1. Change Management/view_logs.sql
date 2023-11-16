SELECT * 
  FROM (SELECT pg_ls_dir('pg_log')) AS tmp (filename)
         WHERE filename LIKE '%csv'
           AND EXISTS (SELECT 1
                         FROM pg_stat_file('pg_log/'||filename)
                        WHERE not isdir)
				ORDER BY 1 DESC
				LIMIT 1; -- to get the latest filename

SELECT size FROM pg_stat_file('pg_log/enterprisedb-2015-06-10.csv'); -- to get the size of the latest filename
SELECT pg_read_file('pg_log/enterprisedb-2015-06-10.csv', 0, 5918) as contents; -- to get the contents of the latest filename