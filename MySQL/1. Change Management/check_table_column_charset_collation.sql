SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE, TABLE_ROWS, DATA_LENGTH, INDEX_LENGTH, TABLE_COLLATION, CREATE_TIME, UPDATE_TIME, TABLE_COMMENT
     , CONCAT('ALTER TABLE ', TABLE_SCHEMA, '.', TABLE_NAME, ' DEFAULT CHARSET = ''utf8mb4'' COLLATE = ''utf8mb4_bin'';') AS ALTER_DDL
  FROM INFORMATION_SCHEMA.TABLES
 WHERE TABLE_COLLATION <> 'utf8mb4_bin'
   AND TABLE_SCHEMA NOT IN ('sys','performance_schema','information_schema','mysql')
   AND TABLE_TYPE = 'BASE TABLE' 
 ORDER BY 1,2,3;

SELECT A.TABLE_SCHEMA
     , A.TABLE_NAME
	 , A.COLUMN_NAME
	 , A.ORDINAL_POSITION
	 , A.COLUMN_DEFAULT
	 , A.IS_NULLABLE
	 , A.COLUMN_TYPE
	 , A.CHARACTER_SET_NAME
	 , A.COLLATION_NAME
	 , A.COLUMN_KEY
	 , A.COLUMN_COMMENT
     , CONCAT('ALTER TABLE ', A.TABLE_SCHEMA, '.', A.TABLE_NAME, ' MODIFY COLUMN ', A.COLUMN_NAME, ' ', A.COLUMN_TYPE, CASE A.IS_NULLABLE WHEN 'NO' THEN ' NOT NULL ' WHEN 'YES' THEN ' NULL ' END, CASE WHEN A.COLUMN_DEFAULT IS NULL THEN '' ELSE CONCAT('DEFAULT ''', A.COLUMN_DEFAULT, '''') END, ' COLLATE ''utf8mb4_bin'' COMMENT ''', A.COLUMN_COMMENT, ''';' ) AS ALTER_DDL
  FROM INFORMATION_SCHEMA.COLUMNS A
 INNER JOIN INFORMATION_SCHEMA.TABLES B
    ON A.TABLE_CATALOG = B.TABLE_CATALOG
   AND A.TABLE_SCHEMA = B.TABLE_SCHEMA
   AND A.TABLE_NAME = B.TABLE_NAME
 WHERE (A.CHARACTER_SET_NAME <> 'utf8mb4' OR A.COLLATION_NAME <> 'utf8mb4_bin') 
   AND A.TABLE_SCHEMA NOT IN ('sys','performance_schema','information_schema','mysql') 
   AND B.TABLE_TYPE = 'BASE TABLE'
 ORDER BY 1,2,4;