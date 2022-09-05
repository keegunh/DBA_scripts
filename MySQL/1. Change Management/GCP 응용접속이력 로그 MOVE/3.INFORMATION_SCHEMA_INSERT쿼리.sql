SELECT CONCAT('INSERT INTO TABLES VALUES (',
       '''', TABLE_CATALOG, ''', '
     , '''', TABLE_SCHEMA, ''', '
     , '''', TABLE_NAME, ''', '
     , '''', TABLE_TYPE, ''''
     , IF(ENGINE IS NULL, ', ', ', '''), IFNULL(ENGINE, 'NULL'), IF(ENGINE IS NULL, '', '''')
     , ', ', IFNULL(VERSION, 'NULL')
     , IF(ROW_FORMAT IS NULL, ', ', ', '''), IFNULL(ROW_FORMAT, 'NULL'), IF(ROW_FORMAT IS NULL, '', '''')
     , ', ', IFNULL(TABLE_ROWS, 'NULL')
     , ', ', IFNULL(AVG_ROW_LENGTH, 'NULL')
     , ', ', IFNULL(DATA_LENGTH, 'NULL')
     , ', ', IFNULL(MAX_DATA_LENGTH, 'NULL')	 
     , ', ', IFNULL(INDEX_LENGTH, 'NULL')	 
     , ', ', IFNULL(DATA_FREE, 'NULL')	 
     , ', ', IFNULL(AUTO_INCREMENT, 'NULL')	 
     , ', ''', CREATE_TIME, ''''
     , IF(UPDATE_TIME IS NULL, ', ', ', '''), IFNULL(UPDATE_TIME, 'NULL'), IF(UPDATE_TIME IS NULL, '', '''')
     , IF(CHECK_TIME IS NULL, ', ', ', '''), IFNULL(CHECK_TIME, 'NULL'), IF(CHECK_TIME IS NULL, '', '''')
     , IF(TABLE_COLLATION IS NULL, ', ', ', '''), IFNULL(TABLE_COLLATION, 'NULL'), IF(TABLE_COLLATION IS NULL, '', '''')
     , ', ', IFNULL(CHECKSUM, 'NULL')
     , IF(CREATE_OPTIONS IS NULL, ', ', ', '''), IFNULL(CREATE_OPTIONS, 'NULL'), IF(CREATE_OPTIONS IS NULL, '', '''')
     , IF(REPLACE(TABLE_COMMENT,'''', '''''') IS NULL, ', ', ', '''), IFNULL(REPLACE(TABLE_COMMENT,'''', ''''''), 'NULL'), IF(REPLACE(TABLE_COMMENT,'''', '''''') IS NULL, '', '''')
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.TABLES;

SELECT CONCAT('INSERT INTO COLUMNS VALUES (',
       '''', TABLE_CATALOG, ''', '
     , '''', TABLE_SCHEMA, ''', '
     , '''', TABLE_NAME, ''''
     , IF(COLUMN_NAME IS NULL, ', ', ', '''), IFNULL(COLUMN_NAME, 'NULL'), IF(COLUMN_NAME IS NULL, '', '''')
     , ', ', ORDINAL_POSITION
     , IF(COLUMN_DEFAULT IS NULL, ', ', ', '''), IFNULL(COLUMN_DEFAULT, 'NULL'), IF(COLUMN_DEFAULT IS NULL, '', '''')
     , ', ''', IS_NULLABLE, ''''
     , IF(DATA_TYPE IS NULL, ', ', ', '''), IFNULL(DATA_TYPE, 'NULL'), IF(DATA_TYPE IS NULL, '', '''')
     , ', ', IFNULL(CHARACTER_MAXIMUM_LENGTH, 'NULL')
     , ', ', IFNULL(CHARACTER_OCTET_LENGTH, 'NULL')
     , ', ', IFNULL(NUMERIC_PRECISION, 'NULL')
     , ', ', IFNULL(NUMERIC_SCALE, 'NULL')
     , ', ', IFNULL(DATETIME_PRECISION, 'NULL')
     , IF(CHARACTER_SET_NAME IS NULL, ', ', ', '''), IFNULL(CHARACTER_SET_NAME, 'NULL'), IF(CHARACTER_SET_NAME IS NULL, '', '''')
     , IF(COLLATION_NAME IS NULL, ', ', ', '''), IFNULL(COLLATION_NAME, 'NULL'), IF(COLLATION_NAME IS NULL, '', '''')
     , ', ''', REPLACE(COLUMN_TYPE,'''', ''''''), ''', '
     , '''', COLUMN_KEY, ''''
     , IF(EXTRA IS NULL, ', ', ', '''), IFNULL(EXTRA, 'NULL'), IF(EXTRA IS NULL, '', '''')
     , IF(PRIVILEGES IS NULL, ', ', ', '''), IFNULL(PRIVILEGES, 'NULL'), IF(PRIVILEGES IS NULL, '', '''')
     , ', ''', REPLACE(COLUMN_COMMENT,'''', ''''''), ''''
     , ', ''', REPLACE(REPLACE(GENERATION_EXPRESSION,'\\', ''),'''', ''''''), ''''
     , IF(SRS_ID IS NULL, ', ', ', '''), IFNULL(SRS_ID, 'NULL'), IF(SRS_ID IS NULL, '', '''')
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.COLUMNS;

SELECT CONCAT('INSERT INTO PARTITIONS VALUES (',
       '''', TABLE_CATALOG, ''', '
     , '''', TABLE_SCHEMA, ''', '
     , '''', TABLE_NAME, ''''
     , IF(PARTITION_NAME IS NULL, ', ', ', '''), IFNULL(PARTITION_NAME, 'NULL'), IF(PARTITION_NAME IS NULL, '', '''')
     , IF(SUBPARTITION_NAME IS NULL, ', ', ', '''), IFNULL(SUBPARTITION_NAME, 'NULL'), IF(SUBPARTITION_NAME IS NULL, '', '''')
     , ', ', IFNULL(PARTITION_ORDINAL_POSITION, 'NULL')
     , ', ', IFNULL(SUBPARTITION_ORDINAL_POSITION, 'NULL')
     , IF(PARTITION_METHOD IS NULL, ', ', ', '''), IFNULL(PARTITION_METHOD, 'NULL'), IF(PARTITION_METHOD IS NULL, '', '''')
     , IF(SUBPARTITION_METHOD IS NULL, ', ', ', '''), IFNULL(SUBPARTITION_METHOD, 'NULL'), IF(SUBPARTITION_METHOD IS NULL, '', '''')
     , IF(REPLACE(PARTITION_EXPRESSION,'''', '''''') IS NULL, ', ', ', '''), IFNULL(REPLACE(PARTITION_EXPRESSION,'''', ''''''), 'NULL'), IF(REPLACE(PARTITION_EXPRESSION,'''', '''''') IS NULL, '', '''')
     , IF(REPLACE(SUBPARTITION_EXPRESSION,'''', '''''') IS NULL, ', ', ', '''), IFNULL(REPLACE(SUBPARTITION_EXPRESSION,'''', ''''''), 'NULL'), IF(REPLACE(SUBPARTITION_EXPRESSION,'''', '''''') IS NULL, '', '''')
     , IF(REPLACE(PARTITION_DESCRIPTION,'''', '''''') IS NULL, ', ', ', '''), IFNULL(REPLACE(PARTITION_DESCRIPTION,'''', ''''''), 'NULL'), IF(REPLACE(PARTITION_DESCRIPTION,'''', '''''') IS NULL, '', '''')
     , ', ', IFNULL(TABLE_ROWS, 'NULL')
     , ', ', IFNULL(AVG_ROW_LENGTH, 'NULL')
     , ', ', IFNULL(DATA_LENGTH, 'NULL')
     , ', ', IFNULL(MAX_DATA_LENGTH, 'NULL')
     , ', ', IFNULL(INDEX_LENGTH, 'NULL')
     , ', ', IFNULL(DATA_FREE, 'NULL')
     , ', ''', CREATE_TIME, ''''
     , IF(UPDATE_TIME IS NULL, ', ', ', '''), IFNULL(UPDATE_TIME, 'NULL'), IF(UPDATE_TIME IS NULL, '', '''')
     , IF(CHECK_TIME IS NULL, ', ', ', '''), IFNULL(CHECK_TIME, 'NULL'), IF(CHECK_TIME IS NULL, '', '''')
     , ', ', IFNULL(CHECKSUM, 'NULL')
     , IF(REPLACE(PARTITION_COMMENT,'''', '''''') IS NULL, ', ', ', '''), IFNULL(REPLACE(PARTITION_COMMENT,'''', ''''''), 'NULL'), IF(REPLACE(PARTITION_COMMENT,'''', '''''') IS NULL, '', '''')
     , IF(NODEGROUP IS NULL, ', ', ', '''), IFNULL(NODEGROUP, 'NULL'), IF(NODEGROUP IS NULL, '', '''')
     , IF(TABLESPACE_NAME IS NULL, ', ', ', '''), IFNULL(TABLESPACE_NAME, 'NULL'), IF(TABLESPACE_NAME IS NULL, '', '''')
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.PARTITIONS;

SELECT CONCAT('INSERT INTO STATISTICS VALUES (',
       '''', TABLE_CATALOG, ''', '
     , '''', TABLE_SCHEMA, ''', '
     , '''', TABLE_NAME, ''''
     , ', ', NON_UNIQUE
     , ', ''', INDEX_SCHEMA, ''''
     , IF(INDEX_NAME IS NULL, ', ', ', '''), IFNULL(INDEX_NAME, 'NULL'), IF(INDEX_NAME IS NULL, '', '''')
     , ', ', SEQ_IN_INDEX
     , IF(COLUMN_NAME IS NULL, ', ', ', '''), IFNULL(COLUMN_NAME, 'NULL'), IF(COLUMN_NAME IS NULL, '', '''')
     , IF(COLLATION IS NULL, ', ', ', '''), IFNULL(COLLATION, 'NULL'), IF(COLLATION IS NULL, '', '''')
     , ', ', IFNULL(CARDINALITY, 'NULL')
     , ', ', IFNULL(SUB_PART, 'NULL')
     , ', ', IFNULL(PACKED, 'NULL')
     , ', ''', NULLABLE, ''''
     , ', ''', INDEX_TYPE, ''''
     , ', ''', REPLACE(COMMENT,'''', ''''''), ''''
     , ', ''', REPLACE(INDEX_COMMENT,'''', ''''''), ''''
     , ', ''', IS_VISIBLE, ''''
     , IF(REPLACE(EXPRESSION,'''', '''''') IS NULL, ', ', ', '''), IFNULL(REPLACE(EXPRESSION,'''', ''''''), 'NULL'), IF(REPLACE(EXPRESSION,'''', '''''') IS NULL, '', '''')
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.STATISTICS;

SELECT CONCAT('INSERT INTO ROUTINES VALUES (',
       '''', SPECIFIC_NAME, ''', '
     , '''', ROUTINE_CATALOG, ''', '
     , '''', ROUTINE_SCHEMA, ''''
     , ', ''', ROUTINE_NAME, ''''
     , ', ''', ROUTINE_TYPE, ''''
     , IF(REPLACE(DATA_TYPE,'''', '''''') IS NULL, ', ', ', '''), IFNULL(REPLACE(DATA_TYPE,'''', ''''''), 'NULL'), IF(REPLACE(DATA_TYPE,'''', '''''') IS NULL, '', '''')
     , ', ', IFNULL(CHARACTER_MAXIMUM_LENGTH, 'NULL')
     , ', ', IFNULL(CHARACTER_OCTET_LENGTH, 'NULL')
     , ', ', IFNULL(NUMERIC_PRECISION, 'NULL')
     , ', ', IFNULL(NUMERIC_SCALE, 'NULL')
     , ', ', IFNULL(DATETIME_PRECISION, 'NULL')
     , IF(CHARACTER_SET_NAME IS NULL, ', ', ', '''), IFNULL(CHARACTER_SET_NAME, 'NULL'), IF(CHARACTER_SET_NAME IS NULL, '', '''')
     , IF(COLLATION_NAME IS NULL, ', ', ', '''), IFNULL(COLLATION_NAME, 'NULL'), IF(COLLATION_NAME IS NULL, '', '''')
     , IF(REPLACE(DTD_IDENTIFIER,'''', '''''') IS NULL, ', ', ', '''), IFNULL(REPLACE(DTD_IDENTIFIER,'''', ''''''), 'NULL'), IF(REPLACE(DTD_IDENTIFIER,'''', '''''') IS NULL, '', '''')
     , ', ''', ROUTINE_BODY, ''''
     , IF(REPLACE(REPLACE(ROUTINE_DEFINITION,'\\', ''),'''', '''''') IS NULL, ', ', ', '''), IFNULL(REPLACE(REPLACE(ROUTINE_DEFINITION,'\\', ''),'''', ''''''), 'NULL'), IF(REPLACE(REPLACE(ROUTINE_DEFINITION,'\\', ''),'''', '''''') IS NULL, '', '''')
     , ', ', IFNULL(EXTERNAL_NAME, 'NULL')
     , ', ''', EXTERNAL_LANGUAGE, ''''
     , ', ''', PARAMETER_STYLE, ''''
     , ', ''', IS_DETERMINISTIC, ''''
     , ', ''', SQL_DATA_ACCESS, ''''
     , ', ', IFNULL(SQL_PATH, 'NULL')
     , ', ''', SECURITY_TYPE, ''''
     , ', ''', CREATED, ''''
     , ', ''', LAST_ALTERED, ''''
     , ', ''', SQL_MODE, ''''
     , ', ''', REPLACE(REPLACE(ROUTINE_COMMENT,'\\', ''),'''', ''''''), ''''
     , ', ''', REPLACE(DEFINER,'''', ''''''), ''''
     , ', ''', CHARACTER_SET_CLIENT, ''''
     , ', ''', COLLATION_CONNECTION, ''''
     , ', ''', DATABASE_COLLATION, ''''
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.ROUTINES;

SELECT CONCAT('INSERT INTO TRIGGERS VALUES (',
       '''', TRIGGER_CATALOG, ''''
     , ', ''', TRIGGER_SCHEMA, ''''
     , ', ''', TRIGGER_NAME, ''''
     , ', ''', EVENT_MANIPULATION, ''''
     , ', ''', EVENT_OBJECT_CATALOG, ''''
     , ', ''', EVENT_OBJECT_SCHEMA, ''''
     , ', ''', EVENT_OBJECT_TABLE, ''''
     , ', ', ACTION_ORDER
     , ', ', IFNULL(ACTION_CONDITION, 'NULL')
     , ', ''', REPLACE(ACTION_STATEMENT,'''', ''''''), ''''
     , ', ''', ACTION_ORIENTATION, ''''
     , ', ''', ACTION_TIMING, ''''
     , ', ', IFNULL(ACTION_REFERENCE_OLD_TABLE, 'NULL')
     , ', ', IFNULL(ACTION_REFERENCE_NEW_TABLE, 'NULL')
     , ', ''', ACTION_REFERENCE_OLD_ROW, ''''
     , ', ''', ACTION_REFERENCE_NEW_ROW, ''''
     , ', ''', CREATED, ''''
     , ', ''', SQL_MODE, ''''
     , ', ''', DEFINER, ''''
     , ', ''', CHARACTER_SET_CLIENT, ''''
     , ', ''', COLLATION_CONNECTION, ''''
     , ', ''', DATABASE_COLLATION, ''''
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.TRIGGERS;

SELECT CONCAT('INSERT INTO VIEWS VALUES (',
       '''', TABLE_CATALOG, ''''
     , ', ''', TABLE_SCHEMA, ''''
     , ', ''', TABLE_NAME, ''''
     , IF(REPLACE(REPLACE(VIEW_DEFINITION,'\\', ''),'''', '''''') IS NULL, ', ', ', '''), IFNULL(REPLACE(REPLACE(VIEW_DEFINITION,'\\', ''),'''', ''''''), 'NULL'), IF(REPLACE(REPLACE(VIEW_DEFINITION,'\\', ''),'''', '''''') IS NULL, '', '''')
     , IF(CHECK_OPTION IS NULL, ', ', ', '''), IFNULL(CHECK_OPTION, 'NULL'), IF(CHECK_OPTION IS NULL, '', '''')
     , IF(IS_UPDATABLE IS NULL, ', ', ', '''), IFNULL(IS_UPDATABLE, 'NULL'), IF(IS_UPDATABLE IS NULL, '', '''')
     , IF(DEFINER IS NULL, ', ', ', '''), IFNULL(DEFINER, 'NULL'), IF(DEFINER IS NULL, '', '''')
     , IF(SECURITY_TYPE IS NULL, ', ', ', '''), IFNULL(SECURITY_TYPE, 'NULL'), IF(SECURITY_TYPE IS NULL, '', '''')
     , ', ''', CHARACTER_SET_CLIENT, ''''
     , ', ''', COLLATION_CONNECTION, ''''
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.VIEWS;

SELECT CONCAT('INSERT INTO SCHEMATA VALUES (',
       '''', CATALOG_NAME, ''''
     , ', ''', SCHEMA_NAME, ''''
     , ', ''', DEFAULT_CHARACTER_SET_NAME, ''''
     , ', ''', DEFAULT_COLLATION_NAME, ''''
     , ', ', IFNULL(SQL_PATH, 'NULL')
     , ', ''', DEFAULT_ENCRYPTION, ''''
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.SCHEMATA;

SELECT CONCAT('INSERT INTO INNODB_TABLES VALUES (',
       TABLE_ID
     , ', ''', NAME, ''''
     , ', ', FLAG
     , ', ', N_COLS
     , ', ', SPACE
     , IF(ROW_FORMAT IS NULL, ', ', ', '''), IFNULL(ROW_FORMAT, 'NULL'), IF(ROW_FORMAT IS NULL, '', '''')
     , ', ', ZIP_PAGE_SIZE
     , IF(SPACE_TYPE IS NULL, ', ', ', '''), IFNULL(SPACE_TYPE, 'NULL'), IF(SPACE_TYPE IS NULL, '', '''')
     , ', ', INSTANT_COLS
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.INNODB_TABLES;
  
SELECT CONCAT('INSERT INTO INNODB_TABLESPACES VALUES (',
       SPACE
     , ', ''', NAME, ''''
     , ', ', FLAG
     , IF(ROW_FORMAT IS NULL, ', ', ', '''), IFNULL(ROW_FORMAT, 'NULL'), IF(ROW_FORMAT IS NULL, '', '''')
     , ', ', PAGE_SIZE
     , ', ', ZIP_PAGE_SIZE
     , IF(SPACE_TYPE IS NULL, ', ', ', '''), IFNULL(SPACE_TYPE, 'NULL'), IF(SPACE_TYPE IS NULL, '', '''')
     , ', ', FS_BLOCK_SIZE
     , ', ', FILE_SIZE
     , ', ', ALLOCATED_SIZE
     , IF(SERVER_VERSION IS NULL, ', ', ', '''), IFNULL(SERVER_VERSION, 'NULL'), IF(SERVER_VERSION IS NULL, '', '''')
     , ', ', SPACE_VERSION
     , IF(ENCRYPTION IS NULL, ', ', ', '''), IFNULL(ENCRYPTION, 'NULL'), IF(ENCRYPTION IS NULL, '', '''')
     , IF(STATE IS NULL, ', ', ', '''), IFNULL(STATE, 'NULL'), IF(STATE IS NULL, '', '''')
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.INNODB_TABLESPACES;

SELECT CONCAT('INSERT INTO INNODB_INDEXES VALUES (',
       INDEX_ID
     , ', ''', NAME, ''''
     , ', ', TABLE_ID
     , ', ', TYPE
     , ', ', N_FIELDS
     , ', ', PAGE_NO
     , ', ', SPACE
     , ', ', MERGE_THRESHOLD
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.INNODB_INDEXES;  


cat << EOF > export_sql.json
{
  "exportContext":
  {
    "kind": "sql#exportContext",
    "fileType": "CSV",
    "uri": "gs://gcs-an3-hrcore-stg-bucket-log/db-application-access-history/EXPORT_SQL_TEST21",
    "databases": [
      "INFORMATION_SCHEMA"
    ],
    "csvExportOptions": {
      "selectQuery": "SELECT CONCAT('INSERT INTO INNODB_INDEXES VALUES (',
       INDEX_ID
     , ', ''', NAME, ''''
     , ', ', TABLE_ID
     , ', ', TYPE
     , ', ', N_FIELDS
     , ', ', PAGE_NO
     , ', ', SPACE
     , ', ', MERGE_THRESHOLD
     , ');') AS INSERT_DML
  FROM INFORMATION_SCHEMA.INNODB_INDEXES;",
      "escapeCharacter": "5C",
      "quoteCharacter": "0A",
      "fieldsTerminatedBy": "2C",
      "linesTerminatedBy": "0A"
    }
  }
}
EOF

curl -X POST \
-H "Authorization: Bearer "$(gcloud auth print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
-d @export_sql.json \
"https://sqladmin.googleapis.com/v1/projects/pjt-hrcore-stg-316104/instances/csql-an3-hrcore-portal-stg-mysql/export"




cat <<EOF > import_mysqldump.json
{
  "importContext":
  {
    "uri": "gs://gcs-an3-hrcore-stg-bucket-log/db-application-access-history/EXPORT_SQL_TEST21",
    "database": "STG_PORTAL",
    "kind": "sql#importContext",
    "fileType": "SQL"
  }
}
EOF

curl -X POST \
-H "Authorization: Bearer "$(gcloud auth print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
-d @import_mysqldump.json \
"https://sqladmin.googleapis.com/v1/projects/pjt-hrcore-stg-316104/instances/csql-an3-hrcore-log-stg-mysql/import"