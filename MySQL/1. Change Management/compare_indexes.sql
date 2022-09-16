SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, NON_UNIQUE, INDEX_SCHEMA, INDEX_NAME, SEQ_IN_INDEX, COLUMN_NAME, COLLATION, SUB_PART, PACKED, NULLABLE, INDEX_TYPE, COMMENT, INDEX_COMMENT, IS_VISIBLE, EXPRESSION
  FROM PRD_LGCNS.STATISTICS
 WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
 UNION 
SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, NON_UNIQUE, INDEX_SCHEMA, INDEX_NAME, SEQ_IN_INDEX, COLUMN_NAME, COLLATION, SUB_PART, PACKED, NULLABLE, INDEX_TYPE, COMMENT, INDEX_COMMENT, IS_VISIBLE, EXPRESSION
  FROM PRD_LGC.STATISTICS
 WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
 UNION 
 SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, NON_UNIQUE, INDEX_SCHEMA, INDEX_NAME, SEQ_IN_INDEX, COLUMN_NAME, COLLATION, SUB_PART, PACKED, NULLABLE, INDEX_TYPE, COMMENT, INDEX_COMMENT, IS_VISIBLE, EXPRESSION
  FROM PRD_LGES.STATISTICS
 WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')


-- PRD_PORTAL - (PRD_LGCNS + PRD_LGC + PRD_LGES)
SELECT 'PRD_PORTAL' AS DB_INSTANCE, A.*
  FROM PRD_PORTAL.STATISTICS A
  LEFT OUTER JOIN (SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, NON_UNIQUE, INDEX_SCHEMA, INDEX_NAME, SEQ_IN_INDEX, COLUMN_NAME, COLLATION, SUB_PART, PACKED, NULLABLE, INDEX_TYPE, COMMENT, INDEX_COMMENT, IS_VISIBLE, EXPRESSION
                     FROM PRD_LGCNS.STATISTICS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                    UNION 
                   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, NON_UNIQUE, INDEX_SCHEMA, INDEX_NAME, SEQ_IN_INDEX, COLUMN_NAME, COLLATION, SUB_PART, PACKED, NULLABLE, INDEX_TYPE, COMMENT, INDEX_COMMENT, IS_VISIBLE, EXPRESSION
                     FROM PRD_LGC.STATISTICS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                    UNION 
                   SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, NON_UNIQUE, INDEX_SCHEMA, INDEX_NAME, SEQ_IN_INDEX, COLUMN_NAME, COLLATION, SUB_PART, PACKED, NULLABLE, INDEX_TYPE, COMMENT, INDEX_COMMENT, IS_VISIBLE, EXPRESSION
                     FROM PRD_LGES.STATISTICS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
				   ) B
    ON B.TABLE_CATALOG = A.TABLE_CATALOG
   AND B.TABLE_SCHEMA = A.TABLE_SCHEMA
   AND B.TABLE_NAME = A.TABLE_NAME
   AND B.INDEX_SCHEMA = A.INDEX_SCHEMA
   AND B.INDEX_NAME = A.INDEX_NAME
   AND B.COLUMN_NAME = A.COLUMN_NAME
 WHERE B.SEQ_IN_INDEX IS NULL
   AND A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
   
   
   
   
 UNION ALL
-- PRD_LGCNS - (PRD_PORTAL + PRD_LGC + PRD_LGES)
SELECT 'PRD_LGCNS' AS DB_INSTANCE, A.*
  FROM PRD_LGCNS.COLUMNS A
  LEFT OUTER JOIN (SELECT *
                     FROM PRD_PORTAL.COLUMNS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                    UNION
                   SELECT *
                     FROM PRD_LGC.COLUMNS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                    UNION
                   SELECT *
                     FROM PRD_LGES.COLUMNS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
				   ) B
    ON B.TABLE_CATALOG = A.TABLE_CATALOG
   AND B.TABLE_SCHEMA = A.TABLE_SCHEMA
   AND B.TABLE_NAME = A.TABLE_NAME
   -- AND B.ORDINAL_POSITION = A.ORDINAL_POSITION
   AND B.COLUMN_NAME = A.COLUMN_NAME
 WHERE B.IS_NULLABLE IS NULL
   AND A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
 UNION ALL
-- PRD_LGC - (PRD_PORTAL + PRD_LGCNS + PRD_LGES)
SELECT 'PRD_LGC' AS DB_INSTANCE, A.*
  FROM PRD_LGC.COLUMNS A
  LEFT OUTER JOIN (SELECT *
                     FROM PRD_PORTAL.COLUMNS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                    UNION
                   SELECT *
                     FROM PRD_LGCNS.COLUMNS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                    UNION
                   SELECT *
                     FROM PRD_LGES.COLUMNS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
				   ) B
    ON B.TABLE_CATALOG = A.TABLE_CATALOG
   AND B.TABLE_SCHEMA = A.TABLE_SCHEMA
   AND B.TABLE_NAME = A.TABLE_NAME
   -- AND B.ORDINAL_POSITION = A.ORDINAL_POSITION
   AND B.COLUMN_NAME = A.COLUMN_NAME
 WHERE B.IS_NULLABLE IS NULL
   AND A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
 UNION ALL
-- PRD_LGES - (PRD_PORTAL + PRD_LGCNS + PRD_LGC)
SELECT 'PRD_LGES' AS DB_INSTANCE, A.*
  FROM PRD_PORTAL.COLUMNS A
  LEFT OUTER JOIN (SELECT *
                     FROM PRD_PORTAL.COLUMNS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                    UNION
                   SELECT *
                     FROM PRD_LGCNS.COLUMNS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
                    UNION
                   SELECT *
                     FROM PRD_LGC.COLUMNS
                    WHERE TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
				   ) B
    ON B.TABLE_CATALOG = A.TABLE_CATALOG
   AND B.TABLE_SCHEMA = A.TABLE_SCHEMA
   AND B.TABLE_NAME = A.TABLE_NAME
   -- AND B.ORDINAL_POSITION = A.ORDINAL_POSITION
   AND B.COLUMN_NAME = A.COLUMN_NAME
 WHERE B.IS_NULLABLE IS NULL
   AND A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
;