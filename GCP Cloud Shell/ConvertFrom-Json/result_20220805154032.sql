# Time: 2022-08-03T10:01:14.047227Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986090  server_id: 1710140860
# Query_time: 4.434337  Lock_time: 0.000507 Rows_sent: 10000  Rows_examined: 13568512
SET timestamp=1659520869;
SELECT D.CUD_KEY
      ,D.EMP_ID
      ,D.PARENT_SEQ_ID
      ,D.CAREER_ID
      ,D.SF_KEY_ID1
      ,D.SF_LST_UPDT_DT
      ,D.COMP_TYPE
      ,D.COMP_NM
      ,D.STRT_DATE
      ,D.END_DATE
      ,D.ORG_NM
      ,D.JOB_TITLE_NM
      ,D.JOB_NM
      ,D.CNTRY_CD
      ,D.REP_COMP_CD
      ,D.COMP_CD
      ,D.EMP_NO
      ,D.SF_USER_ID
      ,D.SF_PERSON_ID
      ,D.ROW_NUM
      ,D.TOTAL_CNT 
FROM (
       WITH RCV AS (
            SELECT HICP.SEQ_ID    AS PARENT_SEQ_ID
           ,IFNULL (HICP.LEGACYKEY,HICP.SF_KEY_ID1) AS SF_KEY_ID1
           ,HICP.SF_LST_UPDT_DT
           ,HICP.COMP_TYPE
           ,HICP.COMP_NM
           ,HICP.STRT_DATE
           ,HICP.END_DATE
           ,HICP.ORG_NM
           ,HICP.JOB_TITLE_NM
           ,HICP.JOB_NM
       --  ,HICP.CNTRY_CD
           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = HICP.CNTRY_CD) AS CNTRY_CD       
           ,HPM.REP_COMP_CD
           ,HPM.COMP_CD
           ,HPM.EMP_NO
           ,HICP.SF_USER_ID
           ,HPM.SF_PERSON_ID
           ,HPM.EMP_ID
       FROM HR_IF_PSN_CAREER_PRE_RCV HICP 
       JOIN HR_PSN_MST HPM
         ON HICP.SF_USER_ID = HPM.SF_USER_ID
       WHERE HICP.TRANSFER_FLAG = 'N'
        AND  HPM.REP_COMP_CD IS NOT NULL
        AND  HPM.COMP_CD IS NOT NULL
        AND  HPM.EMP_NO IS NOT NULL
        AND  HICP.SF_KEY_ID1 IS NOT NULL
/*       
WHERE */
)
       SELECT CASE WHEN  CAREER.CAREER_ID IS NULL THEN  'C' 
                   WHEN  IFNULL(RCV.COMP_TYPE,'X') <>  IFNULL(CAREER.COMP_TYPE,'X') THEN 'U' 
                   WHEN  IFNULL(RCV.COMP_NM,'X') <>  IFNULL(CAREER.COMP_NM,'X') THEN 'U'
                   WHEN  IFNULL(RCV.COMP_NM,'X') <>  IFNULL(CAREER.COMP_NM,'X') THEN 'U'
                   WHEN  IFNULL(RCV.STRT_DATE,'X') <>  IFNULL(CAREER.STRT_DATE,'X') THEN 'U'
                   WHEN  IFNULL(RCV.END_DATE,'X') <>  IFNULL(CAREER.END_DATE,'X') THEN 'U'
                   WHEN  IFNULL(RCV.ORG_NM,'X') <>  IFNULL(CAREER.ORG_NM,'X') THEN 'U'
                   WHEN  IFNULL(RCV.JOB_TITLE_NM,'X') <>  IFNULL(CAREER.JOB_TITLE_NM,'X') THEN 'U'
                   WHEN  IFNULL(RCV.JOB_NM,'X') <>  IFNULL(CAREER.JOB_NM,'X') THEN 'U'
                   WHEN  IFNULL(RCV.CNTRY_CD,'X') <>  IFNULL(CAREER.CNTRY_CD,'X') THEN 'U'
              ELSE 'N' END AS 'CUD_KEY'
             ,RCV.EMP_ID
             ,RCV.PARENT_SEQ_ID
             ,CAREER.CAREER_ID
             ,RCV.SF_KEY_ID1
             ,RCV.SF_LST_UPDT_DT
             ,RCV.COMP_TYPE
             ,RCV.COMP_NM
             ,RCV.STRT_DATE
             ,RCV.END_DATE
             ,RCV.ORG_NM
             ,RCV.JOB_TITLE_NM
             ,RCV.JOB_NM
             ,RCV.CNTRY_CD
             ,RCV.REP_COMP_CD
             ,RCV.COMP_CD
             ,RCV.EMP_NO
             ,RCV.SF_USER_ID
             ,RCV.SF_PERSON_ID
             ,ROW_NUMBER() OVER(ORDER BY RCV.PARENT_SEQ_ID ASC) AS ROW_NUM
             ,COUNT(1) OVER() AS TOTAL_CNT
       FROM RCV 
       LEFT JOIN HR_PSN_CAREER CAREER
         ON RCV.EMP_ID = CAREER.EMP_ID
        AND RCV.SF_KEY_ID1 = CAREER.SF_KEY_ID1
 ) D
 WHERE ROW_NUM BETWEEN ( (1 * 10000) - (10000-1)) AND 1 * 10000
/* [BizActor].[DAC_HR_PSN_IF_CareerInfoIF_Adhoc].[DAS_HR_RetrieveCareerPreRcvListCUN] */;
# Time: 2022-08-03T10:01:22.410671Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986090  server_id: 1710140860
# Query_time: 4.367113  Lock_time: 0.000394 Rows_sent: 10000  Rows_examined: 13568512
SET timestamp=1659520878;
SELECT D.CUD_KEY
      ,D.EMP_ID
      ,D.PARENT_SEQ_ID
      ,D.CAREER_ID
      ,D.SF_KEY_ID1
      ,D.SF_LST_UPDT_DT
      ,D.COMP_TYPE
      ,D.COMP_NM
      ,D.STRT_DATE
      ,D.END_DATE
      ,D.ORG_NM
      ,D.JOB_TITLE_NM
      ,D.JOB_NM
      ,D.CNTRY_CD
      ,D.REP_COMP_CD
      ,D.COMP_CD
      ,D.EMP_NO
      ,D.SF_USER_ID
      ,D.SF_PERSON_ID
      ,D.ROW_NUM
      ,D.TOTAL_CNT 
FROM (
       WITH RCV AS (
            SELECT HICP.SEQ_ID    AS PARENT_SEQ_ID
           ,IFNULL (HICP.LEGACYKEY,HICP.SF_KEY_ID1) AS SF_KEY_ID1
           ,HICP.SF_LST_UPDT_DT
           ,HICP.COMP_TYPE
           ,HICP.COMP_NM
           ,HICP.STRT_DATE
           ,HICP.END_DATE
           ,HICP.ORG_NM
           ,HICP.JOB_TITLE_NM
           ,HICP.JOB_NM
       --  ,HICP.CNTRY_CD
           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = HICP.CNTRY_CD) AS CNTRY_CD       
           ,HPM.REP_COMP_CD
           ,HPM.COMP_CD
           ,HPM.EMP_NO
           ,HICP.SF_USER_ID
           ,HPM.SF_PERSON_ID
           ,HPM.EMP_ID
       FROM HR_IF_PSN_CAREER_PRE_RCV HICP 
       JOIN HR_PSN_MST HPM
         ON HICP.SF_USER_ID = HPM.SF_USER_ID
       WHERE HICP.TRANSFER_FLAG = 'N'
        AND  HPM.REP_COMP_CD IS NOT NULL
        AND  HPM.COMP_CD IS NOT NULL
        AND  HPM.EMP_NO IS NOT NULL
        AND  HICP.SF_KEY_ID1 IS NOT NULL
/*       
WHERE */
)
       SELECT CASE WHEN  CAREER.CAREER_ID IS NULL THEN  'C' 
                   WHEN  IFNULL(RCV.COMP_TYPE,'X') <>  IFNULL(CAREER.COMP_TYPE,'X') THEN 'U' 
                   WHEN  IFNULL(RCV.COMP_NM,'X') <>  IFNULL(CAREER.COMP_NM,'X') THEN 'U'
                   WHEN  IFNULL(RCV.COMP_NM,'X') <>  IFNULL(CAREER.COMP_NM,'X') THEN 'U'
                   WHEN  IFNULL(RCV.STRT_DATE,'X') <>  IFNULL(CAREER.STRT_DATE,'X') THEN 'U'
                   WHEN  IFNULL(RCV.END_DATE,'X') <>  IFNULL(CAREER.END_DATE,'X') THEN 'U'
                   WHEN  IFNULL(RCV.ORG_NM,'X') <>  IFNULL(CAREER.ORG_NM,'X') THEN 'U'
                   WHEN  IFNULL(RCV.JOB_TITLE_NM,'X') <>  IFNULL(CAREER.JOB_TITLE_NM,'X') THEN 'U'
                   WHEN  IFNULL(RCV.JOB_NM,'X') <>  IFNULL(CAREER.JOB_NM,'X') THEN 'U'
                   WHEN  IFNULL(RCV.CNTRY_CD,'X') <>  IFNULL(CAREER.CNTRY_CD,'X') THEN 'U'
              ELSE 'N' END AS 'CUD_KEY'
             ,RCV.EMP_ID
             ,RCV.PARENT_SEQ_ID
             ,CAREER.CAREER_ID
             ,RCV.SF_KEY_ID1
             ,RCV.SF_LST_UPDT_DT
             ,RCV.COMP_TYPE
             ,RCV.COMP_NM
             ,RCV.STRT_DATE
             ,RCV.END_DATE
             ,RCV.ORG_NM
             ,RCV.JOB_TITLE_NM
             ,RCV.JOB_NM
             ,RCV.CNTRY_CD
             ,RCV.REP_COMP_CD
             ,RCV.COMP_CD
             ,RCV.EMP_NO
             ,RCV.SF_USER_ID
             ,RCV.SF_PERSON_ID
             ,ROW_NUMBER() OVER(ORDER BY RCV.PARENT_SEQ_ID ASC) AS ROW_NUM
             ,COUNT(1) OVER() AS TOTAL_CNT
       FROM RCV 
       LEFT JOIN HR_PSN_CAREER CAREER
         ON RCV.EMP_ID = CAREER.EMP_ID
        AND RCV.SF_KEY_ID1 = CAREER.SF_KEY_ID1
 ) D
 WHERE ROW_NUM BETWEEN ( (2 * 10000) - (10000-1)) AND 2 * 10000
/* [BizActor].[DAC_HR_PSN_IF_CareerInfoIF_Adhoc].[DAS_HR_RetrieveCareerPreRcvListCUN] */;
# Time: 2022-08-03T10:01:30.492899Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986090  server_id: 1710140860
# Query_time: 4.341192  Lock_time: 0.000389 Rows_sent: 10000  Rows_examined: 13568512
SET timestamp=1659520886;
SELECT D.CUD_KEY
      ,D.EMP_ID
      ,D.PARENT_SEQ_ID
      ,D.CAREER_ID
      ,D.SF_KEY_ID1
      ,D.SF_LST_UPDT_DT
      ,D.COMP_TYPE
      ,D.COMP_NM
      ,D.STRT_DATE
      ,D.END_DATE
      ,D.ORG_NM
      ,D.JOB_TITLE_NM
      ,D.JOB_NM
      ,D.CNTRY_CD
      ,D.REP_COMP_CD
      ,D.COMP_CD
      ,D.EMP_NO
      ,D.SF_USER_ID
      ,D.SF_PERSON_ID
      ,D.ROW_NUM
      ,D.TOTAL_CNT 
FROM (
       WITH RCV AS (
            SELECT HICP.SEQ_ID    AS PARENT_SEQ_ID
           ,IFNULL (HICP.LEGACYKEY,HICP.SF_KEY_ID1) AS SF_KEY_ID1
           ,HICP.SF_LST_UPDT_DT
           ,HICP.COMP_TYPE
           ,HICP.COMP_NM
           ,HICP.STRT_DATE
