SELECT X.*
  FROM (SELECT 'PRD_PORTAL' AS DB_INSTANCE, A.*
          FROM PRD_PORTAL.TABLES A
         WHERE A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
           AND (A.TABLE_NAME LIKE '%BACKUP%'
            OR A.TABLE_NAME LIKE '%BACK%'
            OR A.TABLE_NAME LIKE '%BK%'
            OR A.TABLE_NAME LIKE '%TMP%'
            OR A.TABLE_NAME LIKE '%TEMP%'
            OR A.TABLE_NAME LIKE '%20%'
            OR A.TABLE_NAME LIKE '%19%'
            OR A.TABLE_NAME LIKE '%TEST%')
           AND A.TABLE_TYPE = 'BASE TABLE'
         UNION ALL
        SELECT 'PRD_LGCNS' AS DB_INSTANCE, A.*
          FROM PRD_LGCNS.TABLES A
         WHERE A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
           AND (A.TABLE_NAME LIKE '%BACKUP%'
            OR A.TABLE_NAME LIKE '%BACK%'
            OR A.TABLE_NAME LIKE '%BK%'
            OR A.TABLE_NAME LIKE '%TMP%'
            OR A.TABLE_NAME LIKE '%TEMP%'
            OR A.TABLE_NAME LIKE '%20%'
            OR A.TABLE_NAME LIKE '%19%'
            OR A.TABLE_NAME LIKE '%TEST%')
           AND A.TABLE_TYPE = 'BASE TABLE'
         UNION ALL
        SELECT 'PRD_LGC' AS DB_INSTANCE, A.*
          FROM PRD_LGC.TABLES A
         WHERE A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
           AND (A.TABLE_NAME LIKE '%BACKUP%'
            OR A.TABLE_NAME LIKE '%BACK%'
            OR A.TABLE_NAME LIKE '%BK%'
            OR A.TABLE_NAME LIKE '%TMP%'
            OR A.TABLE_NAME LIKE '%TEMP%'
            OR A.TABLE_NAME LIKE '%20%'
            OR A.TABLE_NAME LIKE '%19%'
            OR A.TABLE_NAME LIKE '%TEST%')
           AND A.TABLE_TYPE = 'BASE TABLE'
         UNION ALL
        SELECT 'PRD_LGES' AS DB_INSTANCE, A.*
          FROM PRD_LGES.TABLES A
         WHERE A.TABLE_SCHEMA NOT IN ('information_schema', 'performance_schema', 'sys', 'mysql')
           AND (A.TABLE_NAME LIKE '%BACKUP%'
            OR A.TABLE_NAME LIKE '%BACK%'
            OR A.TABLE_NAME LIKE '%BK%'
            OR A.TABLE_NAME LIKE '%TMP%'
            OR A.TABLE_NAME LIKE '%TEMP%'
            OR A.TABLE_NAME LIKE '%20%'
            OR A.TABLE_NAME LIKE '%19%'
            OR A.TABLE_NAME LIKE '%TEST%')
           AND A.TABLE_TYPE = 'BASE TABLE') X
 WHERE X.TABLE_NAME NOT IN (''
  'CM_MSG_TEMPLATE'
, 'CM_ROLE_MSG_TEMPLATE'
, 'HR_CM_TNA_BATCH_TEMP'
, 'HR_CM_TNA_BATCH_TEMP_INFO'
, 'HR_CODE_TRANS_TEMP'
, 'HR_IF_ECP_ZHRT0201_SEND'
, 'HR_IF_ECP_ZHRT0202_SEND'
, 'HR_IF_ECP_ZHRT0203_SEND'
, 'HR_IF_ECP_ZHRT0204_SEND'
, 'HR_IF_ECP_ZHRT0205_SEND'
, 'HR_IF_ECP_ZHRT0206_SEND'
, 'HR_IF_ECP_ZHRT0207_SEND'
, 'HR_PRM_TEST_RSLT'
, 'HR_PRM_TEST_RSLT_UPLOAD'
, 'SF_API_LATEST'
, 'HR_ANAL_TMP_ORG_MBR_CNT');