SELECT nspname
     , pg_get_userbyid(nspowner) AS owner
     , nspacl
  FROM pg_namespace
 ORDER BY nspname;