-- PRD_PORTAL - (PRD_LGCNS + PRD_LGC + PRD_LGES)
SELECT 'PRD_PORTAL' AS DB_INSTANCE, A.TABLE_CATALOG, A.TABLE_SCHEMA, A.TABLE_NAME, A.TABLE_TYPE, A.ENGINE, A.VERSION, A.ROW_FORMAT, A.TABLE_COLLATION, A.TABLE_COMMENT
  FROM PRD_PORTAL.TABLES A
  LEFT OUTER JOIN (SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_LGCNS.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW'
                    UNION
                   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_LGC.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW'
                    UNION
                   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_LGES.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW') B
    ON B.TABLE_CATALOG = A.TABLE_CATALOG
   AND B.TABLE_SCHEMA = A.TABLE_SCHEMA
   AND B.TABLE_NAME = A.TABLE_NAME
 WHERE B.TABLE_TYPE IS NULL
   AND A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
   AND A.TABLE_TYPE = 'VIEW'
 UNION ALL
-- PRD_LGCNS - (PRD_PORTAL + PRD_LGC + PRD_LGES)
SELECT 'PRD_LGCNS' AS DB_INSTANCE, A.TABLE_CATALOG, A.TABLE_SCHEMA, A.TABLE_NAME, A.TABLE_TYPE, A.ENGINE, A.VERSION, A.ROW_FORMAT, A.TABLE_COLLATION, A.TABLE_COMMENT
  FROM PRD_LGCNS.TABLES A
  LEFT OUTER JOIN (SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_PORTAL.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW'
                    UNION
                   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_LGC.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW'
                    UNION
                   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_LGES.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW') B
    ON B.TABLE_CATALOG = A.TABLE_CATALOG
   AND B.TABLE_SCHEMA = A.TABLE_SCHEMA
   AND B.TABLE_NAME = A.TABLE_NAME
 WHERE B.TABLE_TYPE IS NULL
   AND A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
   AND A.TABLE_TYPE = 'VIEW'
 UNION ALL
-- PRD_LGC - (PRD_PORTAL + PRD_LGCNS + PRD_LGES)
SELECT 'PRD_LGC' AS DB_INSTANCE, A.TABLE_CATALOG, A.TABLE_SCHEMA, A.TABLE_NAME, A.TABLE_TYPE, A.ENGINE, A.VERSION, A.ROW_FORMAT, A.TABLE_COLLATION, A.TABLE_COMMENT
  FROM PRD_LGC.TABLES A
  LEFT OUTER JOIN (SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_PORTAL.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW'
                    UNION
                   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_LGCNS.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW'
                    UNION
                   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_LGES.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW') B
    ON B.TABLE_CATALOG = A.TABLE_CATALOG
   AND B.TABLE_SCHEMA = A.TABLE_SCHEMA
   AND B.TABLE_NAME = A.TABLE_NAME
 WHERE B.TABLE_TYPE IS NULL
   AND A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
   AND A.TABLE_TYPE = 'VIEW'
 UNION ALL
-- PRD_LGES - (PRD_PORTAL + PRD_LGCNS + PRD_LGC)
SELECT 'PRD_LGES' AS DB_INSTANCE, A.TABLE_CATALOG, A.TABLE_SCHEMA, A.TABLE_NAME, A.TABLE_TYPE, A.ENGINE, A.VERSION, A.ROW_FORMAT, A.TABLE_COLLATION, A.TABLE_COMMENT
  FROM PRD_LGES.TABLES A
  LEFT OUTER JOIN (SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_PORTAL.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW'
                    UNION
                   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_LGCNS.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW'
                    UNION
                   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, ENGINE, VERSION, ROW_FORMAT, TABLE_COLLATION, TABLE_COMMENT
                     FROM PRD_LGC.TABLES
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                      AND TABLE_TYPE = 'VIEW') B
    ON B.TABLE_CATALOG = A.TABLE_CATALOG
   AND B.TABLE_SCHEMA = A.TABLE_SCHEMA
   AND B.TABLE_NAME = A.TABLE_NAME
 WHERE B.TABLE_TYPE IS NULL
   AND A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
   AND A.TABLE_TYPE = 'VIEW'
;