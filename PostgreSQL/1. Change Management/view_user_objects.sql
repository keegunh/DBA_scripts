SELECT pg_get_userbyid(relowner) AS rolname
     , CASE WHEN relkind='r' THEN 'table'
            WHEN relkind='i' THEN 'index'
            WHEN relkind='S' THEN 'sequence'
            WHEN relkind='v' THEN 'view'
            WHEN relkind='c' THEN 'composite type'
            WHEN relkind='t' THEN 'TOAST table'
            ELSE ''
       END AS kind
     , COUNT(*) AS total
  FROM pg_class
 GROUP BY 1, 2
 ORDER BY 1, 2;