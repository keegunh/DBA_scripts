SELECT e.name
     , e.default_version
     , x.extversion AS installed_version
     , r.rolname as owner
     , n.nspname as namespace
     , x.extrelocatable
     , x.extconfig
     , x.extcondition
     , e.comment
  FROM pg_available_extensions() e(name, default_version, comment)
  LEFT JOIN pg_extension x
    ON e.name = x.extname
  LEFT JOIN pg_roles r
    ON r.oid=x.extowner
  LEFT JOIN pg_namespace n
    ON n.oid=x.extnamespace
 ORDER BY 1;