SELECT * 
  FROM pg_ls_dir('pg_wal')
 WHERE pg_ls_dir ~ E'^[0-9A-F]{24}$'
 ORDER BY 1;

SELECT size, access, modification, change, creation, isdir FROM pg_stat_file('pg_wal/000000010000000000000001');




SELECT size
     , access
     , modification
     , change
     , creation
     , isdir 
  FROM pg_stat_file('pg_wal/000000010000000000000001');
  
SELECT a.pg_stat_file
  FROM (SELECT pg_stat_file('pg_wal/'|| pg_ls_dir)
          FROM pg_ls_dir('pg_wal')
         WHERE pg_ls_dir ~ E'^[0-9A-F]{24}$'
         ORDER BY 1) AS a;