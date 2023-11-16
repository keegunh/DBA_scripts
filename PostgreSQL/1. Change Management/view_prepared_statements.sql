SELECT name
     , statement
     , prepare_time
     , from_sql
  FROM pg_prepared_statements
 ORDER BY name;