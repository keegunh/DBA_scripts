/*
* 용도       : PNP정산시스템 개발(DNUPB) vs 운영(PNUPB) DB 오브젝트 비교
* 수행DB     : PNUPB
* 마지막수정일자 : 2021.11.04
*
* DB에 존재하는 유저 : 'APPMMGR', 'BMC_ESS', 'EDDSEL', 'EVNTADM', 'EVNTAPP', 'EVNTDEV', 'PMPBADM', 'PMPBAPP', 'PMPBBAT', 'WFFWADM', 'VERTI_CON', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM', 'OGGAPT01', 'OGGAPT02', 'OGGAPT03', 'OGGAPT04', 'OGGAPT05', 'OGGAPT06', 'OGGAPT07', 'OGGAPT08', 'OGGAPT09', 'OGGAPT10'
*
*/

-- ################ 일반테이블 비교 ################
-- TABLES 비교
SELECT OWNER, TABLE_NAME, TABLESPACE_NAME, PARTITIONED FROM DBA_TABLES WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT OWNER, TABLE_NAME, TABLESPACE_NAME, PARTITIONED FROM DBA_TABLES@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');
SELECT OWNER, TABLE_NAME, TABLESPACE_NAME, PARTITIONED FROM DBA_TABLES@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT OWNER, TABLE_NAME, TABLESPACE_NAME, PARTITIONED FROM DBA_TABLES WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');

-- TAB_COLUMNS 비교 
SELECT OWNER, TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID FROM DBA_TAB_COLUMNS WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS 
SELECT OWNER, TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID FROM DBA_TAB_COLUMNS@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');
SELECT OWNER, TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID FROM DBA_TAB_COLUMNS@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS 
SELECT OWNER, TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID FROM DBA_TAB_COLUMNS WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');

-- INDEXES 비교
SELECT TABLE_OWNER, TABLE_NAME, TABLE_TYPE, OWNER, INDEX_NAME, INDEX_TYPE FROM DBA_INDEXES WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM') AND INDEX_TYPE < > 'LOB'
MINUS
SELECT TABLE_OWNER, TABLE_NAME, TABLE_TYPE, OWNER, INDEX_NAME, INDEX_TYPE FROM DBA_INDEXES@DL_DNUPB WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM') AND INDEX_TYPE < > 'LOB';
SELECT TABLE_OWNER, TABLE_NAME, TABLE_TYPE, OWNER, INDEX_NAME, INDEX_TYPE FROM DBA_INDEXES@DL_DNUPB WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM') AND INDEX_TYPE < > 'LOB'
MINUS
SELECT TABLE_OWNER, TABLE_NAME, TABLE_TYPE, OWNER, INDEX_NAME, INDEX_TYPE FROM DBA_INDEXES WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM') AND INDEX_TYPE < > 'LOB';

-- IND_COLUMNS 비교 
SELECT TABLE_OWNER, TABLE_NAME, INDEX_OWNER, INDEX_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND, COLLATED_COLUMN_ID FROM DBA_IND_COLUMNS WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT TABLE_OWNER, TABLE_NAME, INDEX_OWNER, INDEX_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND, COLLATED_COLUMN_ID FROM DBA_IND_COLUMNS@DL_DNUPB WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');
SELECT TABLE_OWNER, TABLE_NAME, INDEX_OWNER, INDEX_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND, COLLATED_COLUMN_ID FROM DBA_IND_COLUMNS@DL_DNUPB WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT TABLE_OWNER, TABLE_NAME, INDEX_OWNER, INDEX_NAME, COLUMN_NAME, COLUMN_POSITION, COLUMN_LENGTH, CHAR_LENGTH, DESCEND, COLLATED_COLUMN_ID FROM DBA_IND_COLUMNS WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');

-- CONSTRAINTS 비교 
SELECT OWNER, TABLE_NAME, CASE WHEN CONSTRAINT_TYPE='P' THEN CONSTRAINT_NAME ELSE NULL END AS CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION_VC, STATUS, DEFERRABLE, DEFERRED, VALIDATED, GENERATED FROM DBA_CONSTRAINTS WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT OWNER, TABLE_NAME, CASE WHEN CONSTRAINT_TYPE='P' THEN CONSTRAINT_NAME ELSE NULL END AS CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION_VC, STATUS, DEFERRABLE, DEFERRED, VALIDATED, GENERATED FROM DBA_CONSTRAINTS@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');
SELECT OWNER, TABLE_NAME, CASE WHEN CONSTRAINT_TYPE='P' THEN CONSTRAINT_NAME ELSE NULL END AS CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION_VC, STATUS, DEFERRABLE, DEFERRED, VALIDATED, GENERATED FROM DBA_CONSTRAINTS@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT OWNER, TABLE_NAME, CASE WHEN CONSTRAINT_TYPE='P' THEN CONSTRAINT_NAME ELSE NULL END AS CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION_VC, STATUS, DEFERRABLE, DEFERRED, VALIDATED, GENERATED FROM DBA_CONSTRAINTS WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');


-- ################ 파티션테이블 비교 ################
-- PART_TABLES 비교
SELECT OWNER, TABLE_NAME, PARTITIONING_TYPE, SUBPARTITIONING_TYPE, PARTITION_COUNT, DEF_SUBPARTITION_COUNT, PARTITIONING_KEY_COUNT, SUBPARTITIONING_KEY_COUNT, STATUS, DEF_TABLESPACE_NAME, DEF_PCT_FREE, DEF_PCT_USED FROM DBA_PART_TABLES WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT OWNER, TABLE_NAME, PARTITIONING_TYPE, SUBPARTITIONING_TYPE, PARTITION_COUNT, DEF_SUBPARTITION_COUNT, PARTITIONING_KEY_COUNT, SUBPARTITIONING_KEY_COUNT, STATUS, DEF_TABLESPACE_NAME, DEF_PCT_FREE, DEF_PCT_USED FROM DBA_PART_TABLES@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');
SELECT OWNER, TABLE_NAME, PARTITIONING_TYPE, SUBPARTITIONING_TYPE, PARTITION_COUNT, DEF_SUBPARTITION_COUNT, PARTITIONING_KEY_COUNT, SUBPARTITIONING_KEY_COUNT, STATUS, DEF_TABLESPACE_NAME, DEF_PCT_FREE, DEF_PCT_USED FROM DBA_PART_TABLES@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT OWNER, TABLE_NAME, PARTITIONING_TYPE, SUBPARTITIONING_TYPE, PARTITION_COUNT, DEF_SUBPARTITION_COUNT, PARTITIONING_KEY_COUNT, SUBPARTITIONING_KEY_COUNT, STATUS, DEF_TABLESPACE_NAME, DEF_PCT_FREE, DEF_PCT_USED FROM DBA_PART_TABLES WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');

-- TAB_PARTITIONS 비교
SELECT TABLE_OWNER, TABLE_NAME, COMPOSITE, PARTITION_NAME, SUBPARTITION_COUNT, HIGH_VALUE_LENGTH, PARTITION_POSITION, TABLESPACE_NAME, PCT_FREE, PCT_USED FROM DBA_TAB_PARTITIONS WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT TABLE_OWNER, TABLE_NAME, COMPOSITE, PARTITION_NAME, SUBPARTITION_COUNT, HIGH_VALUE_LENGTH, PARTITION_POSITION, TABLESPACE_NAME, PCT_FREE, PCT_USED FROM DBA_TAB_PARTITIONS@DL_DNUPB WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');
SELECT TABLE_OWNER, TABLE_NAME, COMPOSITE, PARTITION_NAME, SUBPARTITION_COUNT, HIGH_VALUE_LENGTH, PARTITION_POSITION, TABLESPACE_NAME, PCT_FREE, PCT_USED FROM DBA_TAB_PARTITIONS@DL_DNUPB WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT TABLE_OWNER, TABLE_NAME, COMPOSITE, PARTITION_NAME, SUBPARTITION_COUNT, HIGH_VALUE_LENGTH, PARTITION_POSITION, TABLESPACE_NAME, PCT_FREE, PCT_USED FROM DBA_TAB_PARTITIONS WHERE TABLE_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');

-- PART_INDEXES 비교
SELECT OWNER, INDEX_NAME, TABLE_NAME, PARTITIONING_TYPE, SUBPARTITIONING_TYPE, PARTITION_COUNT, DEF_SUBPARTITION_COUNT, PARTITIONING_KEY_COUNT, SUBPARTITIONING_KEY_COUNT, LOCALITY, ALIGNMENT, DEF_TABLESPACE_NAME, DEF_PCT_FREE FROM DBA_PART_INDEXES WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT OWNER, INDEX_NAME, TABLE_NAME, PARTITIONING_TYPE, SUBPARTITIONING_TYPE, PARTITION_COUNT, DEF_SUBPARTITION_COUNT, PARTITIONING_KEY_COUNT, SUBPARTITIONING_KEY_COUNT, LOCALITY, ALIGNMENT, DEF_TABLESPACE_NAME, DEF_PCT_FREE FROM DBA_PART_INDEXES@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');
SELECT OWNER, INDEX_NAME, TABLE_NAME, PARTITIONING_TYPE, SUBPARTITIONING_TYPE, PARTITION_COUNT, DEF_SUBPARTITION_COUNT, PARTITIONING_KEY_COUNT, SUBPARTITIONING_KEY_COUNT, LOCALITY, ALIGNMENT, DEF_TABLESPACE_NAME, DEF_PCT_FREE FROM DBA_PART_INDEXES@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT OWNER, INDEX_NAME, TABLE_NAME, PARTITIONING_TYPE, SUBPARTITIONING_TYPE, PARTITION_COUNT, DEF_SUBPARTITION_COUNT, PARTITIONING_KEY_COUNT, SUBPARTITIONING_KEY_COUNT, LOCALITY, ALIGNMENT, DEF_TABLESPACE_NAME, DEF_PCT_FREE FROM DBA_PART_INDEXES WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');

-- IND_PARTITIONS 비교
SELECT INDEX_OWNER, INDEX_NAME, COMPOSITE, PARTITION_NAME, SUBPARTITION_COUNT, PARTITION_POSITION, STATUS, TABLESPACE_NAME, PCT_FREE FROM DBA_IND_PARTITIONS WHERE INDEX_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT INDEX_OWNER, INDEX_NAME, COMPOSITE, PARTITION_NAME, SUBPARTITION_COUNT, PARTITION_POSITION, STATUS, TABLESPACE_NAME, PCT_FREE FROM DBA_IND_PARTITIONS@DL_DNUPB WHERE INDEX_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');
SELECT INDEX_OWNER, INDEX_NAME, COMPOSITE, PARTITION_NAME, SUBPARTITION_COUNT, PARTITION_POSITION, STATUS, TABLESPACE_NAME, PCT_FREE FROM DBA_IND_PARTITIONS@DL_DNUPB WHERE INDEX_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT INDEX_OWNER, INDEX_NAME, COMPOSITE, PARTITION_NAME, SUBPARTITION_COUNT, PARTITION_POSITION, STATUS, TABLESPACE_NAME, PCT_FREE FROM DBA_IND_PARTITIONS WHERE INDEX_OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');

-- PART_KEY_COLUMNS 비교
SELECT * FROM DBA_PART_KEY_COLUMNS WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT * FROM DBA_PART_KEY_COLUMNS@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');
SELECT * FROM DBA_PART_KEY_COLUMNS@DL_DNUPB WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM')
MINUS
SELECT * FROM DBA_PART_KEY_COLUMNS WHERE OWNER IN ('PMPBADM', 'BLCP01ADM', 'BLCP02ADM', 'BLCP03ADM', 'BLCP04ADM', 'BLCP05ADM', 'BLCP06ADM', 'BLCP07ADM', 'BLCP08ADM', 'BLCP09ADM', 'BLCP10ADM');


-- ################ 코멘트 비교 ################
-- TAB_COMMENTS 비교
SELECT * FROM DBA_TAB_COMMENTS WHERE OWNER = 'PMPBADM'
MINUS 
SELECT * FROM DBA_TAB_COMMENTS@DL_DNUPB WHERE OWNER = 'PMPBADM'; 
SELECT * FROM DBA_TAB_COMMENTS@DL_DNUPB WHERE OWNER = 'PMPBADM'
MINUS
SELECT * FROM DBA_TAB_COMMENTS WHERE OWNER = 'PMPBADM';

-- COL_COMMENTS 비교
SELECT * FROM DBA_COL_COMMENTS WHERE OWNER = 'PMPBADM'
MINUS
SELECT * FROM DBA_COL_COMMENTS@DL_DNUPB WHERE OWNER = 'PMPBADM';
SELECT * FROM DBA_COL_COMMENTS@DL_DNUPB WHERE OWNER = 'PMPBADM'
MINUS
SELECT * FROM DBA_COL_COMMENTS WHERE OWNER = 'PMPBADM';


-- ################ 권한 및 동의어 비교 ################
-- TAB_PRIVS 비교
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTOR = 'PMPBADM'
MINUS
SELECT * FROM DBA_TAB_PRIVS@DL_DNUPB WHERE GRANTOR = 'PMPBADM';
SELECT * FROM DBA_TAB_PRIVS@DL_DNUPB WHERE GRANTOR = 'PMPBADM'
MINUS
SELECT * FROM DBA_TAB_PRIVS WHERE GRANTOR = 'PMPBADM';

-- SYNONYMS 비교
SELECT * FROM DBA_SYNONYMS WHERE OWNER = 'PMPBADM'
MINUS
SELECT * FROM DBA_SYNONYMS@DL_DNUPB WHERE OWNER = 'PMPBADM';
SELECT * FROM DBA_SYNONYMS@DL_DNUPB WHERE OWNER = 'PMPBADM'
MINUS
SELECT * FROM DBA_SYNONYMS WHERE OWNER = 'PMPBADM';


-- ################ 기타 오브젝트 비교 ################
-- PROCEDURES 비교 (TRIGGER, FUNCTION 포함)
SELECT OWNER, OBJECT_NAME, PROCEDURE_NAME, SUBPROGRAM_ID, OVERLOAD, OBJECT_TYPE, AGGREGATE, PIPELINED, IMPLTYPEOWNER, IMPLTYPENAME, PARALLEL, INTERFACE, DETERMINISTIC, AUTHID, RESULT_CACHE, ORIGIN_CON_ID, POLYMORPHIC FROM DBA_PROCEDURES WHERE OWNER = 'PMPBADM'
MINUS
SELECT OWNER, OBJECT_NAME, PROCEDURE_NAME, SUBPROGRAM_ID, OVERLOAD, OBJECT_TYPE, AGGREGATE, PIPELINED, IMPLTYPEOWNER, IMPLTYPENAME, PARALLEL, INTERFACE, DETERMINISTIC, AUTHID, RESULT_CACHE, ORIGIN_CON_ID, POLYMORPHIC FROM DBA_PROCEDURES@DL_DNUPB WHERE OWNER = 'PMPBADM';
SELECT OWNER, OBJECT_NAME, PROCEDURE_NAME, SUBPROGRAM_ID, OVERLOAD, OBJECT_TYPE, AGGREGATE, PIPELINED, IMPLTYPEOWNER, IMPLTYPENAME, PARALLEL, INTERFACE, DETERMINISTIC, AUTHID, RESULT_CACHE, ORIGIN_CON_ID, POLYMORPHIC FROM DBA_PROCEDURES@DL_DNUPB WHERE OWNER = 'PMPBADM'
MINUS
SELECT OWNER, OBJECT_NAME, PROCEDURE_NAME, SUBPROGRAM_ID, OVERLOAD, OBJECT_TYPE, AGGREGATE, PIPELINED, IMPLTYPEOWNER, IMPLTYPENAME, PARALLEL, INTERFACE, DETERMINISTIC, AUTHID, RESULT_CACHE, ORIGIN_CON_ID, POLYMORPHIC FROM DBA_PROCEDURES WHERE OWNER = 'PMPBADM';

-- VIEWS 비교
SELECT OWNER, VIEW_NAME, TEXT_LENGTH, TEXT_VC, TYPE_TEXT_LENGTH, TYPE_TEXT, OID_TEXT_LENGTH, OID_TEXT, VIEW_TYPE_OWNER, VIEW_TYPE, SUPERVIEW_NAME, EDITIONING_VIEW, READ_ONLY, CONTAINER_DATA, BEQUEATH, ORIGIN_CON_ID, DEFAULT_COLLATION, CONTAINERS_DEFAULT, CONTAINER_MAP, EXTENDED_DATA_LINK, EXTENDED_DATA_LINK_MAP, HAS_SENSITIVE_COLUMN, ADMIT_NULL, PDB_LOCAL_ONLY FROM DBA_VIEWS WHERE OWNER = 'PMPBADM'
MINUS
SELECT OWNER, VIEW_NAME, TEXT_LENGTH, TEXT_VC, TYPE_TEXT_LENGTH, TYPE_TEXT, OID_TEXT_LENGTH, OID_TEXT, VIEW_TYPE_OWNER, VIEW_TYPE, SUPERVIEW_NAME, EDITIONING_VIEW, READ_ONLY, CONTAINER_DATA, BEQUEATH, ORIGIN_CON_ID, DEFAULT_COLLATION, CONTAINERS_DEFAULT, CONTAINER_MAP, EXTENDED_DATA_LINK, EXTENDED_DATA_LINK_MAP, HAS_SENSITIVE_COLUMN, ADMIT_NULL, PDB_LOCAL_ONLY FROM DBA_VIEWS@DL_DNUPB WHERE OWNER = 'PMPBADM';
SELECT OWNER, VIEW_NAME, TEXT_LENGTH, TEXT_VC, TYPE_TEXT_LENGTH, TYPE_TEXT, OID_TEXT_LENGTH, OID_TEXT, VIEW_TYPE_OWNER, VIEW_TYPE, SUPERVIEW_NAME, EDITIONING_VIEW, READ_ONLY, CONTAINER_DATA, BEQUEATH, ORIGIN_CON_ID, DEFAULT_COLLATION, CONTAINERS_DEFAULT, CONTAINER_MAP, EXTENDED_DATA_LINK, EXTENDED_DATA_LINK_MAP, HAS_SENSITIVE_COLUMN, ADMIT_NULL, PDB_LOCAL_ONLY FROM DBA_VIEWS@DL_DNUPB WHERE OWNER = 'PMPBADM'
MINUS
SELECT OWNER, VIEW_NAME, TEXT_LENGTH, TEXT_VC, TYPE_TEXT_LENGTH, TYPE_TEXT, OID_TEXT_LENGTH, OID_TEXT, VIEW_TYPE_OWNER, VIEW_TYPE, SUPERVIEW_NAME, EDITIONING_VIEW, READ_ONLY, CONTAINER_DATA, BEQUEATH, ORIGIN_CON_ID, DEFAULT_COLLATION, CONTAINERS_DEFAULT, CONTAINER_MAP, EXTENDED_DATA_LINK, EXTENDED_DATA_LINK_MAP, HAS_SENSITIVE_COLUMN, ADMIT_NULL, PDB_LOCAL_ONLY FROM DBA_VIEWS WHERE OWNER = 'PMPBADM';

-- SEQUENCES 비교
SELECT SEQUENCE_OWNER, SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE, SCALE_FLAG, EXTEND_FLAG, SHARDED_FLAG, SESSION_FLAG, KEEP_VALUE FROM DBA_SEQUENCES WHERE SEQUENCE_OWNER = 'PMPBADM'
MINUS
SELECT SEQUENCE_OWNER, SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE, SCALE_FLAG, EXTEND_FLAG, SHARDED_FLAG, SESSION_FLAG, KEEP_VALUE FROM DBA_SEQUENCES@DL_DNUPB WHERE SEQUENCE_OWNER = 'PMPBADM';
SELECT SEQUENCE_OWNER, SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE, SCALE_FLAG, EXTEND_FLAG, SHARDED_FLAG, SESSION_FLAG, KEEP_VALUE FROM DBA_SEQUENCES@DL_DNUPB WHERE SEQUENCE_OWNER = 'PMPBADM'
MINUS
SELECT SEQUENCE_OWNER, SEQUENCE_NAME, MIN_VALUE, MAX_VALUE, INCREMENT_BY, CYCLE_FLAG, ORDER_FLAG, CACHE_SIZE, SCALE_FLAG, EXTEND_FLAG, SHARDED_FLAG, SESSION_FLAG, KEEP_VALUE FROM DBA_SEQUENCES WHERE SEQUENCE_OWNER = 'PMPBADM';