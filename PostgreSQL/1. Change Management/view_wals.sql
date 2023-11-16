SELECT * 
  FROM pg_ls_dir('pg_xlog')
 WHERE pg_ls_dir ~ E'^[0-9A-F]{24}$'
 ORDER BY 1;

SELECT size, access, modification, change, creation, isdir FROM pg_stat_file('pg_xlog/000000010000000000000002');
SELECT size, access, modification, change, creation, isdir FROM pg_stat_file('pg_xlog/000000010000000000000003');