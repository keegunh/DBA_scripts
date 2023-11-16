SELECT pg_get_userbyid(relowner) AS tableowner
     , nspname
     , relname AS tablename
     , conname
     , pg_get_constraintdef(pg_constraint.oid, true) as condef
  FROM pg_constraint
     , pg_class
     , pg_namespace
 WHERE conrelid=pg_class.oid
   AND relnamespace=pg_namespace.oid
   AND contype = 'f'
 ORDER BY 1, 2, 3;