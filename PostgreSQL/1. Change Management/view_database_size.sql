-- https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-ADMIN-DBSIZE

select datname as db_name
     , pg_size_pretty(pg_database_size(datname)) as size
     , pg_encoding_to_char(encoding) as charset_encoding
     , datcollate
     , datctype
  from pg_catalog.pg_database;