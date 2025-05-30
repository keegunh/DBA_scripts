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
 WHERE ROW_NUM BETWEEN ( (3 * 10000) - (10000-1)) AND 3 * 10000
/* [BizActor].[DAC_HR_PSN_IF_CareerInfoIF_Adhoc].[DAS_HR_RetrieveCareerPreRcvListCUN] */;
# Time: 2022-08-03T10:01:38.825382Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986090  server_id: 1710140860
# Query_time: 4.397579  Lock_time: 0.000383 Rows_sent: 10000  Rows_examined: 13568512
SET timestamp=1659520894;
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
 WHERE ROW_NUM BETWEEN ( (4 * 10000) - (10000-1)) AND 4 * 10000
/* [BizActor].[DAC_HR_PSN_IF_CareerInfoIF_Adhoc].[DAS_HR_RetrieveCareerPreRcvListCUN] */;
# Time: 2022-08-03T10:01:42.586585Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986108  server_id: 1710140860
# Query_time: 6.225264  Lock_time: 0.000526 Rows_sent: 10000  Rows_examined: 17949954
SET timestamp=1659520896;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_PERSON_ID
      ,T.EMP_NO
      ,T.SF_USER_ID
      ,T.PARENT_SEQ_ID
      ,T.CHILD_SEQ_ID
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      ,T.EDU_LVL_ID
      ,T.STRT_DATE
      ,T.END_DATE
      ,T.EDU_LVL_CD
      ,T.SCHL_CNTRY_CD
      ,T.SCHL_CD
      ,T.SCHL_NM
      ,T.SCHL_NM_DESC
      ,T.MAJOR_SERIES_CD
      ,T.MAJOR_SERIES_NM
      ,T.MAJOR_NM
      ,T.DBL_MAJOR_NM
      ,T.MINOR_NM
      ,T.GRADU_CD
      ,T.DGR_CD
      ,T.DGR_NO
      ,T.LST_EDU_LVL_YN
      ,T.HIRE_AFT_FLAG
      ,T.HEDU_TITLE
      ,T.DURATION_HEDU
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HPM.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,PPP.SEQ_ID AS PARENT_SEQ_ID
                           ,CCC.SEQ_ID AS CHILD_SEQ_ID
                           ,CCC.SF_KEY_ID1
                           ,PPP.SF_LST_UPDT_DT
                           -- ??숆탳 ?댁긽 ?숇젰 ?뺣낫 硫붿씤
                           ,CCC.STRT_DATE
                           ,CCC.END_DATE
                           ,'80' AS EDU_LVL_CD
                        --  ,CCC.SCHL_CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = CCC.SCHL_CNTRY_CD) AS SCHL_CNTRY_CD 
                           ,CCC.SCHL_CD
                           ,CCC.SCHL_NM
                           ,CCC.SCHL_NM_DESC
                           ,CCC.MAJOR_SERIES_CD
                           ,CCC.MAJOR_SERIES_NM
                           ,CCC.MAJOR_NM
                           ,CCC.DBL_MAJOR_NM
                           ,CCC.MINOR_NM
                           ,CCC.GRADU_CD
                           ,CCC.DGR_CD
                           ,CCC.DGR_NO
                           ,CCC.LST_EDU_LVL_YN
                           ,CCC.HIRE_AFT_FLAG
                           ,CCC.HEDU_TITLE
                           ,CCC.DURATION_HEDU
                     FROM   HR_IF_PSN_HEDU_LEVEL_P_PRE_RCV  PPP
                     JOIN   HR_IF_PSN_HEDU_LEVEL_C_PRE_RCV  CCC
                            ON  PPP.SF_USER_ID = CCC.SF_USER_ID
                            AND PPP.TRANSFER_FLAG = CCC.TRANSFER_FLAG
                     JOIN   HR_PSN_MST HPM
                            ON PPP.SF_USER_ID = HPM.SF_USER_ID
                     WHERE  PPP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
                     AND    HPM.EMP_NO IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_PERSON_ID
              ,RCV.EMP_NO
              ,RCV.SF_USER_ID
              ,RCV.PARENT_SEQ_ID
              ,RCV.CHILD_SEQ_ID
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              ,HPEL.EDU_LVL_ID
              --  ?숇젰 ?뺣낫 硫붿씤
              ,RCV.STRT_DATE
              ,RCV.END_DATE
              ,RCV.EDU_LVL_CD
              ,RCV.SCHL_CNTRY_CD
              ,RCV.SCHL_CD
              ,RCV.SCHL_NM
              ,RCV.SCHL_NM_DESC
              ,RCV.MAJOR_SERIES_CD
              ,RCV.MAJOR_SERIES_NM
              ,RCV.MAJOR_NM
              ,RCV.DBL_MAJOR_NM
              ,RCV.MINOR_NM
              ,RCV.GRADU_CD
              ,RCV.DGR_CD
              ,RCV.DGR_NO
              ,RCV.LST_EDU_LVL_YN
              ,RCV.HIRE_AFT_FLAG
              ,RCV.HEDU_TITLE
              ,RCV.DURATION_HEDU
              ,CASE WHEN HPEL.EDU_LVL_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.STRT_DATE,'X') <> IFNULL(HPEL.STRT_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.END_DATE,'X') <> IFNULL(HPEL.END_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CD,'X') <> IFNULL(HPEL.SCHL_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_NM,'X') <> IFNULL(HPEL.SCHL_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.GRADU_CD,'X') <> IFNULL(HPEL.GRADU_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.LST_EDU_LVL_YN, 'X') <> IFNULL(HPEL.LST_EDU_LVL_YN,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CNTRY_CD , 'X') <> IFNULL(HPEL.SCHL_CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_CD,'X') <> IFNULL(HPEL.MAJOR_SERIES_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_NM,'X') <> IFNULL(HPEL.MAJOR_SERIES_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_NM,'X') <> IFNULL(HPEL.MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DBL_MAJOR_NM,'X') <> IFNULL(HPEL.DBL_MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MINOR_NM,'X') <> IFNULL(HPEL.MINOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DGR_CD,'X') <> IFNULL(HPEL.DGR_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.HIRE_AFT_FLAG,'X') <> IFNULL(HPEL.HIRE_AFT_FLAG,'X') THEN 'U'
                    WHEN IFNULL(RCV.HEDU_TITLE,'X') <> IFNULL(HPEL.HEDU_TITLE,'X') THEN 'U'
                    WHEN IFNULL(RCV.DURATION_HEDU,'X') <> IFNULL(HPEL.DURATION_HEDU,'X') THEN 'U'
                    ELSE 'N'
               END  AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.parent_seq_id, RCV.child_seq_id) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON HPM.EMP_ID = RCV.EMP_ID
        LEFT OUTER JOIN HR_PSN_HEDU_LEVEL HPEL
                        ON RCV.EMP_ID = HPEL.EMP_ID
                        AND RCV.SF_KEY_ID1 = HPEL.SF_KEY_ID1) T
WHERE  ROW_NUM BETWEEN ((1 * 10000) - (10000 - 1)) AND 1 * 10000
/* [BizActor].[DAC_HR_PSN_IF_HEduLevelInfo_Adhoc].[DAS_HR_RetrieveHEduListCUN] */;
# Time: 2022-08-03T10:01:46.817648Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986090  server_id: 1710140860
# Query_time: 4.360215  Lock_time: 0.000355 Rows_sent: 10000  Rows_examined: 13568512
SET timestamp=1659520902;
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
 WHERE ROW_NUM BETWEEN ( (5 * 10000) - (10000-1)) AND 5 * 10000
/* [BizActor].[DAC_HR_PSN_IF_CareerInfoIF_Adhoc].[DAS_HR_RetrieveCareerPreRcvListCUN] */;
# Time: 2022-08-03T10:01:52.680760Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986108  server_id: 1710140860
# Query_time: 6.318377  Lock_time: 0.000435 Rows_sent: 10000  Rows_examined: 17949954
SET timestamp=1659520906;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_PERSON_ID
      ,T.EMP_NO
      ,T.SF_USER_ID
      ,T.PARENT_SEQ_ID
      ,T.CHILD_SEQ_ID
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      ,T.EDU_LVL_ID
      ,T.STRT_DATE
      ,T.END_DATE
      ,T.EDU_LVL_CD
      ,T.SCHL_CNTRY_CD
      ,T.SCHL_CD
      ,T.SCHL_NM
      ,T.SCHL_NM_DESC
      ,T.MAJOR_SERIES_CD
      ,T.MAJOR_SERIES_NM
      ,T.MAJOR_NM
      ,T.DBL_MAJOR_NM
      ,T.MINOR_NM
      ,T.GRADU_CD
      ,T.DGR_CD
      ,T.DGR_NO
      ,T.LST_EDU_LVL_YN
      ,T.HIRE_AFT_FLAG
      ,T.HEDU_TITLE
      ,T.DURATION_HEDU
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HPM.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,PPP.SEQ_ID AS PARENT_SEQ_ID
                           ,CCC.SEQ_ID AS CHILD_SEQ_ID
                           ,CCC.SF_KEY_ID1
                           ,PPP.SF_LST_UPDT_DT
                           -- ??숆탳 ?댁긽 ?숇젰 ?뺣낫 硫붿씤
                           ,CCC.STRT_DATE
                           ,CCC.END_DATE
                           ,'80' AS EDU_LVL_CD
                        --  ,CCC.SCHL_CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = CCC.SCHL_CNTRY_CD) AS SCHL_CNTRY_CD 
                           ,CCC.SCHL_CD
                           ,CCC.SCHL_NM
                           ,CCC.SCHL_NM_DESC
                           ,CCC.MAJOR_SERIES_CD
                           ,CCC.MAJOR_SERIES_NM
                           ,CCC.MAJOR_NM
                           ,CCC.DBL_MAJOR_NM
                           ,CCC.MINOR_NM
                           ,CCC.GRADU_CD
                           ,CCC.DGR_CD
                           ,CCC.DGR_NO
                           ,CCC.LST_EDU_LVL_YN
                           ,CCC.HIRE_AFT_FLAG
                           ,CCC.HEDU_TITLE
                           ,CCC.DURATION_HEDU
                     FROM   HR_IF_PSN_HEDU_LEVEL_P_PRE_RCV  PPP
                     JOIN   HR_IF_PSN_HEDU_LEVEL_C_PRE_RCV  CCC
                            ON  PPP.SF_USER_ID = CCC.SF_USER_ID
                            AND PPP.TRANSFER_FLAG = CCC.TRANSFER_FLAG
                     JOIN   HR_PSN_MST HPM
                            ON PPP.SF_USER_ID = HPM.SF_USER_ID
                     WHERE  PPP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
                     AND    HPM.EMP_NO IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_PERSON_ID
              ,RCV.EMP_NO
              ,RCV.SF_USER_ID
              ,RCV.PARENT_SEQ_ID
              ,RCV.CHILD_SEQ_ID
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              ,HPEL.EDU_LVL_ID
              --  ?숇젰 ?뺣낫 硫붿씤
              ,RCV.STRT_DATE
              ,RCV.END_DATE
              ,RCV.EDU_LVL_CD
              ,RCV.SCHL_CNTRY_CD
              ,RCV.SCHL_CD
              ,RCV.SCHL_NM
              ,RCV.SCHL_NM_DESC
              ,RCV.MAJOR_SERIES_CD
              ,RCV.MAJOR_SERIES_NM
              ,RCV.MAJOR_NM
              ,RCV.DBL_MAJOR_NM
              ,RCV.MINOR_NM
              ,RCV.GRADU_CD
              ,RCV.DGR_CD
              ,RCV.DGR_NO
              ,RCV.LST_EDU_LVL_YN
              ,RCV.HIRE_AFT_FLAG
              ,RCV.HEDU_TITLE
              ,RCV.DURATION_HEDU
              ,CASE WHEN HPEL.EDU_LVL_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.STRT_DATE,'X') <> IFNULL(HPEL.STRT_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.END_DATE,'X') <> IFNULL(HPEL.END_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CD,'X') <> IFNULL(HPEL.SCHL_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_NM,'X') <> IFNULL(HPEL.SCHL_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.GRADU_CD,'X') <> IFNULL(HPEL.GRADU_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.LST_EDU_LVL_YN, 'X') <> IFNULL(HPEL.LST_EDU_LVL_YN,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CNTRY_CD , 'X') <> IFNULL(HPEL.SCHL_CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_CD,'X') <> IFNULL(HPEL.MAJOR_SERIES_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_NM,'X') <> IFNULL(HPEL.MAJOR_SERIES_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_NM,'X') <> IFNULL(HPEL.MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DBL_MAJOR_NM,'X') <> IFNULL(HPEL.DBL_MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MINOR_NM,'X') <> IFNULL(HPEL.MINOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DGR_CD,'X') <> IFNULL(HPEL.DGR_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.HIRE_AFT_FLAG,'X') <> IFNULL(HPEL.HIRE_AFT_FLAG,'X') THEN 'U'
                    WHEN IFNULL(RCV.HEDU_TITLE,'X') <> IFNULL(HPEL.HEDU_TITLE,'X') THEN 'U'
                    WHEN IFNULL(RCV.DURATION_HEDU,'X') <> IFNULL(HPEL.DURATION_HEDU,'X') THEN 'U'
                    ELSE 'N'
               END  AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.parent_seq_id, RCV.child_seq_id) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON HPM.EMP_ID = RCV.EMP_ID
        LEFT OUTER JOIN HR_PSN_HEDU_LEVEL HPEL
                        ON RCV.EMP_ID = HPEL.EMP_ID
                        AND RCV.SF_KEY_ID1 = HPEL.SF_KEY_ID1) T
WHERE  ROW_NUM BETWEEN ((2 * 10000) - (10000 - 1)) AND 2 * 10000
/* [BizActor].[DAC_HR_PSN_IF_HEduLevelInfo_Adhoc].[DAS_HR_RetrieveHEduListCUN] */;
# Time: 2022-08-03T10:01:55.013900Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986090  server_id: 1710140860
# Query_time: 4.351277  Lock_time: 0.000357 Rows_sent: 3002  Rows_examined: 13568512
SET timestamp=1659520910;
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
 WHERE ROW_NUM BETWEEN ( (6 * 10000) - (10000-1)) AND 6 * 10000
/* [BizActor].[DAC_HR_PSN_IF_CareerInfoIF_Adhoc].[DAS_HR_RetrieveCareerPreRcvListCUN] */;
# Time: 2022-08-03T10:02:02.485417Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986108  server_id: 1710140860
# Query_time: 6.078353  Lock_time: 0.000424 Rows_sent: 10000  Rows_examined: 17949954
SET timestamp=1659520916;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_PERSON_ID
      ,T.EMP_NO
      ,T.SF_USER_ID
      ,T.PARENT_SEQ_ID
      ,T.CHILD_SEQ_ID
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      ,T.EDU_LVL_ID
      ,T.STRT_DATE
      ,T.END_DATE
      ,T.EDU_LVL_CD
      ,T.SCHL_CNTRY_CD
      ,T.SCHL_CD
      ,T.SCHL_NM
      ,T.SCHL_NM_DESC
      ,T.MAJOR_SERIES_CD
      ,T.MAJOR_SERIES_NM
      ,T.MAJOR_NM
      ,T.DBL_MAJOR_NM
      ,T.MINOR_NM
      ,T.GRADU_CD
      ,T.DGR_CD
      ,T.DGR_NO
      ,T.LST_EDU_LVL_YN
      ,T.HIRE_AFT_FLAG
      ,T.HEDU_TITLE
      ,T.DURATION_HEDU
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HPM.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,PPP.SEQ_ID AS PARENT_SEQ_ID
                           ,CCC.SEQ_ID AS CHILD_SEQ_ID
                           ,CCC.SF_KEY_ID1
                           ,PPP.SF_LST_UPDT_DT
                           -- ??숆탳 ?댁긽 ?숇젰 ?뺣낫 硫붿씤
                           ,CCC.STRT_DATE
                           ,CCC.END_DATE
                           ,'80' AS EDU_LVL_CD
                        --  ,CCC.SCHL_CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = CCC.SCHL_CNTRY_CD) AS SCHL_CNTRY_CD 
                           ,CCC.SCHL_CD
                           ,CCC.SCHL_NM
                           ,CCC.SCHL_NM_DESC
                           ,CCC.MAJOR_SERIES_CD
                           ,CCC.MAJOR_SERIES_NM
                           ,CCC.MAJOR_NM
                           ,CCC.DBL_MAJOR_NM
                           ,CCC.MINOR_NM
                           ,CCC.GRADU_CD
                           ,CCC.DGR_CD
                           ,CCC.DGR_NO
                           ,CCC.LST_EDU_LVL_YN
                           ,CCC.HIRE_AFT_FLAG
                           ,CCC.HEDU_TITLE
                           ,CCC.DURATION_HEDU
                     FROM   HR_IF_PSN_HEDU_LEVEL_P_PRE_RCV  PPP
                     JOIN   HR_IF_PSN_HEDU_LEVEL_C_PRE_RCV  CCC
                            ON  PPP.SF_USER_ID = CCC.SF_USER_ID
                            AND PPP.TRANSFER_FLAG = CCC.TRANSFER_FLAG
                     JOIN   HR_PSN_MST HPM
                            ON PPP.SF_USER_ID = HPM.SF_USER_ID
                     WHERE  PPP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
                     AND    HPM.EMP_NO IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_PERSON_ID
              ,RCV.EMP_NO
              ,RCV.SF_USER_ID
              ,RCV.PARENT_SEQ_ID
              ,RCV.CHILD_SEQ_ID
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              ,HPEL.EDU_LVL_ID
              --  ?숇젰 ?뺣낫 硫붿씤
              ,RCV.STRT_DATE
              ,RCV.END_DATE
              ,RCV.EDU_LVL_CD
              ,RCV.SCHL_CNTRY_CD
              ,RCV.SCHL_CD
              ,RCV.SCHL_NM
              ,RCV.SCHL_NM_DESC
              ,RCV.MAJOR_SERIES_CD
              ,RCV.MAJOR_SERIES_NM
              ,RCV.MAJOR_NM
              ,RCV.DBL_MAJOR_NM
              ,RCV.MINOR_NM
              ,RCV.GRADU_CD
              ,RCV.DGR_CD
              ,RCV.DGR_NO
              ,RCV.LST_EDU_LVL_YN
              ,RCV.HIRE_AFT_FLAG
              ,RCV.HEDU_TITLE
              ,RCV.DURATION_HEDU
              ,CASE WHEN HPEL.EDU_LVL_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.STRT_DATE,'X') <> IFNULL(HPEL.STRT_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.END_DATE,'X') <> IFNULL(HPEL.END_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CD,'X') <> IFNULL(HPEL.SCHL_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_NM,'X') <> IFNULL(HPEL.SCHL_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.GRADU_CD,'X') <> IFNULL(HPEL.GRADU_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.LST_EDU_LVL_YN, 'X') <> IFNULL(HPEL.LST_EDU_LVL_YN,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CNTRY_CD , 'X') <> IFNULL(HPEL.SCHL_CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_CD,'X') <> IFNULL(HPEL.MAJOR_SERIES_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_NM,'X') <> IFNULL(HPEL.MAJOR_SERIES_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_NM,'X') <> IFNULL(HPEL.MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DBL_MAJOR_NM,'X') <> IFNULL(HPEL.DBL_MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MINOR_NM,'X') <> IFNULL(HPEL.MINOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DGR_CD,'X') <> IFNULL(HPEL.DGR_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.HIRE_AFT_FLAG,'X') <> IFNULL(HPEL.HIRE_AFT_FLAG,'X') THEN 'U'
                    WHEN IFNULL(RCV.HEDU_TITLE,'X') <> IFNULL(HPEL.HEDU_TITLE,'X') THEN 'U'
                    WHEN IFNULL(RCV.DURATION_HEDU,'X') <> IFNULL(HPEL.DURATION_HEDU,'X') THEN 'U'
                    ELSE 'N'
               END  AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.parent_seq_id, RCV.child_seq_id) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON HPM.EMP_ID = RCV.EMP_ID
        LEFT OUTER JOIN HR_PSN_HEDU_LEVEL HPEL
                        ON RCV.EMP_ID = HPEL.EMP_ID
                        AND RCV.SF_KEY_ID1 = HPEL.SF_KEY_ID1) T
WHERE  ROW_NUM BETWEEN ((3 * 10000) - (10000 - 1)) AND 3 * 10000
/* [BizActor].[DAC_HR_PSN_IF_HEduLevelInfo_Adhoc].[DAS_HR_RetrieveHEduListCUN] */;
# Time: 2022-08-03T10:02:12.581173Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986108  server_id: 1710140860
# Query_time: 6.085272  Lock_time: 0.000462 Rows_sent: 10000  Rows_examined: 17949954
SET timestamp=1659520926;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_PERSON_ID
      ,T.EMP_NO
      ,T.SF_USER_ID
      ,T.PARENT_SEQ_ID
      ,T.CHILD_SEQ_ID
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      ,T.EDU_LVL_ID
      ,T.STRT_DATE
      ,T.END_DATE
      ,T.EDU_LVL_CD
      ,T.SCHL_CNTRY_CD
      ,T.SCHL_CD
      ,T.SCHL_NM
      ,T.SCHL_NM_DESC
      ,T.MAJOR_SERIES_CD
      ,T.MAJOR_SERIES_NM
      ,T.MAJOR_NM
      ,T.DBL_MAJOR_NM
      ,T.MINOR_NM
      ,T.GRADU_CD
      ,T.DGR_CD
      ,T.DGR_NO
      ,T.LST_EDU_LVL_YN
      ,T.HIRE_AFT_FLAG
      ,T.HEDU_TITLE
      ,T.DURATION_HEDU
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HPM.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,PPP.SEQ_ID AS PARENT_SEQ_ID
                           ,CCC.SEQ_ID AS CHILD_SEQ_ID
                           ,CCC.SF_KEY_ID1
                           ,PPP.SF_LST_UPDT_DT
                           -- ??숆탳 ?댁긽 ?숇젰 ?뺣낫 硫붿씤
                           ,CCC.STRT_DATE
                           ,CCC.END_DATE
                           ,'80' AS EDU_LVL_CD
                        --  ,CCC.SCHL_CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = CCC.SCHL_CNTRY_CD) AS SCHL_CNTRY_CD 
                           ,CCC.SCHL_CD
                           ,CCC.SCHL_NM
                           ,CCC.SCHL_NM_DESC
                           ,CCC.MAJOR_SERIES_CD
                           ,CCC.MAJOR_SERIES_NM
                           ,CCC.MAJOR_NM
                           ,CCC.DBL_MAJOR_NM
                           ,CCC.MINOR_NM
                           ,CCC.GRADU_CD
                           ,CCC.DGR_CD
                           ,CCC.DGR_NO
                           ,CCC.LST_EDU_LVL_YN
                           ,CCC.HIRE_AFT_FLAG
                           ,CCC.HEDU_TITLE
                           ,CCC.DURATION_HEDU
                     FROM   HR_IF_PSN_HEDU_LEVEL_P_PRE_RCV  PPP
                     JOIN   HR_IF_PSN_HEDU_LEVEL_C_PRE_RCV  CCC
                            ON  PPP.SF_USER_ID = CCC.SF_USER_ID
                            AND PPP.TRANSFER_FLAG = CCC.TRANSFER_FLAG
                     JOIN   HR_PSN_MST HPM
                            ON PPP.SF_USER_ID = HPM.SF_USER_ID
                     WHERE  PPP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
                     AND    HPM.EMP_NO IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_PERSON_ID
              ,RCV.EMP_NO
              ,RCV.SF_USER_ID
              ,RCV.PARENT_SEQ_ID
              ,RCV.CHILD_SEQ_ID
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              ,HPEL.EDU_LVL_ID
              --  ?숇젰 ?뺣낫 硫붿씤
              ,RCV.STRT_DATE
              ,RCV.END_DATE
              ,RCV.EDU_LVL_CD
              ,RCV.SCHL_CNTRY_CD
              ,RCV.SCHL_CD
              ,RCV.SCHL_NM
              ,RCV.SCHL_NM_DESC
              ,RCV.MAJOR_SERIES_CD
              ,RCV.MAJOR_SERIES_NM
              ,RCV.MAJOR_NM
              ,RCV.DBL_MAJOR_NM
              ,RCV.MINOR_NM
              ,RCV.GRADU_CD
              ,RCV.DGR_CD
              ,RCV.DGR_NO
              ,RCV.LST_EDU_LVL_YN
              ,RCV.HIRE_AFT_FLAG
              ,RCV.HEDU_TITLE
              ,RCV.DURATION_HEDU
              ,CASE WHEN HPEL.EDU_LVL_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.STRT_DATE,'X') <> IFNULL(HPEL.STRT_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.END_DATE,'X') <> IFNULL(HPEL.END_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CD,'X') <> IFNULL(HPEL.SCHL_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_NM,'X') <> IFNULL(HPEL.SCHL_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.GRADU_CD,'X') <> IFNULL(HPEL.GRADU_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.LST_EDU_LVL_YN, 'X') <> IFNULL(HPEL.LST_EDU_LVL_YN,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CNTRY_CD , 'X') <> IFNULL(HPEL.SCHL_CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_CD,'X') <> IFNULL(HPEL.MAJOR_SERIES_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_NM,'X') <> IFNULL(HPEL.MAJOR_SERIES_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_NM,'X') <> IFNULL(HPEL.MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DBL_MAJOR_NM,'X') <> IFNULL(HPEL.DBL_MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MINOR_NM,'X') <> IFNULL(HPEL.MINOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DGR_CD,'X') <> IFNULL(HPEL.DGR_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.HIRE_AFT_FLAG,'X') <> IFNULL(HPEL.HIRE_AFT_FLAG,'X') THEN 'U'
                    WHEN IFNULL(RCV.HEDU_TITLE,'X') <> IFNULL(HPEL.HEDU_TITLE,'X') THEN 'U'
                    WHEN IFNULL(RCV.DURATION_HEDU,'X') <> IFNULL(HPEL.DURATION_HEDU,'X') THEN 'U'
                    ELSE 'N'
               END  AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.parent_seq_id, RCV.child_seq_id) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON HPM.EMP_ID = RCV.EMP_ID
        LEFT OUTER JOIN HR_PSN_HEDU_LEVEL HPEL
                        ON RCV.EMP_ID = HPEL.EMP_ID
                        AND RCV.SF_KEY_ID1 = HPEL.SF_KEY_ID1) T
WHERE  ROW_NUM BETWEEN ((4 * 10000) - (10000 - 1)) AND 4 * 10000
/* [BizActor].[DAC_HR_PSN_IF_HEduLevelInfo_Adhoc].[DAS_HR_RetrieveHEduListCUN] */;
# Time: 2022-08-03T10:02:22.203514Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 10.112400  Lock_time: 0.000723 Rows_sent: 10000  Rows_examined: 26314240
SET timestamp=1659520932;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_USER_ID
      ,T.SF_PERSON_ID
      ,T.SEQ_ID
      ,T.EMP_NO
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      -- 二쇱냼 ?뺣낫 硫붿씤
      ,T.ADDR_TYPE
      ,T.CNTRY_CD
      ,T.POST_CD
      ,T.ADDR1
      ,T.ADDR2
      ,T.ADDR3
      ,T.ADDR4
      ,T.ADDR5
      ,T.ADDR6
      ,T.ADDR7
      ,T.ADDR8
      ,T.ADDR9
      ,T.ADDR10
      ,T.DTL_ADDR1
      ,T.DTL_ADDR2
      ,T.DTL_ADDR3
      ,T.DTL_ADDR4
      ,T.DTL_ADDR5
      ,T.DTL_ADDR6
      ,T.DTL_ADDR7
      ,T.DTL_ADDR8
      ,T.DTL_ADDR9
      ,T.DTL_ADDR10
      ,T.DTL_ADDR11
      ,T.DTL_ADDR12
      ,T.DTL_ADDR13
      ,T.DTL_ADDR14
      ,T.DTL_ADDR15
      ,T.PROVINCE
      ,T.CITY
      ,T.STATE
      ,T.START_DATE
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HIPAP.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,HIPAP.SEQ_ID
                           ,HIPAP.SF_KEY_ID1
                           ,HIPAP.SF_LST_UPDT_DT
                           -- 遺?묎?議깆젙蹂?硫붿씤
                           ,HIPAP.ADDR_TYPE
                        -- ,HIPAP.CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = HIPAP.CNTRY_CD) AS CNTRY_CD                           
                           ,HIPAP.POST_CD
                           ,IFNULL(HIPAP.ADDR1_CD,  HIPAP.ADDR1)  AS ADDR1
                           ,IFNULL(HIPAP.ADDR2_CD,  HIPAP.ADDR2)  AS ADDR2
                           ,IFNULL(HIPAP.ADDR3_CD,  HIPAP.ADDR3)  AS ADDR3
                           ,IFNULL(HIPAP.ADDR4_CD,  HIPAP.ADDR4)  AS ADDR4
                           ,IFNULL(HIPAP.ADDR5_CD,  HIPAP.ADDR5)  AS ADDR5
                           ,IFNULL(HIPAP.ADDR6_CD,  HIPAP.ADDR6)  AS ADDR6
                           ,IFNULL(HIPAP.ADDR7_CD,  HIPAP.ADDR7)  AS ADDR7
                           ,IFNULL(HIPAP.ADDR8_CD,  HIPAP.ADDR8)  AS ADDR8
                           ,IFNULL(HIPAP.ADDR9_CD,  HIPAP.ADDR9)  AS ADDR9
                           ,IFNULL(HIPAP.ADDR10_CD, HIPAP.ADDR10) AS ADDR10
                           ,IFNULL(HIPAP.ADDR11_CD, HIPAP.ADDR11) AS DTL_ADDR1
                           ,IFNULL(HIPAP.ADDR12_CD, HIPAP.ADDR12) AS DTL_ADDR2
                           ,IFNULL(HIPAP.ADDR13_CD, HIPAP.ADDR13) AS DTL_ADDR3
                           ,IFNULL(HIPAP.ADDR14_CD, HIPAP.ADDR14) AS DTL_ADDR4
                           ,IFNULL(HIPAP.ADDR15_CD, HIPAP.ADDR15) AS DTL_ADDR5
                           ,IFNULL(HIPAP.ADDR16_CD, HIPAP.ADDR16) AS DTL_ADDR6
                           ,IFNULL(HIPAP.ADDR17_CD, HIPAP.ADDR17) AS DTL_ADDR7
                           ,IFNULL(HIPAP.ADDR18_CD, HIPAP.ADDR18) AS DTL_ADDR8
                           ,IFNULL(HIPAP.ADDR19_CD, HIPAP.ADDR19) AS DTL_ADDR9
                           ,IFNULL(HIPAP.ADDR20_CD, HIPAP.ADDR20) AS DTL_ADDR10
                           ,HIPAP.CUSTOM_STRING1   AS DTL_ADDR11
                           ,HIPAP.CUSTOM_STRING2 AS DTL_ADDR12
                           ,HIPAP.CUSTOM_STRING3 AS DTL_ADDR13
                           ,HIPAP.CUSTOM_STRING4 AS DTL_ADDR14
                           ,HIPAP.CUSTOM_STRING5 AS DTL_ADDR15
                           ,IFNULL(HIPAP.PROVINCE_CD, HIPAP.PROVINCE) AS PROVINCE
                           ,IFNULL(HIPAP.CITY_CD, HIPAP.CITY) AS CITY
                           ,HIPAP.STATE
                           ,HIPAP.START_DATE
                     FROM   HR_IF_PSN_ADDRESS_PRE_RCV  HIPAP
                     JOIN   (
                             SELECT A.SF_PERSON_ID
                                   ,MAX(A.START_DATE) AS START_DATE
                                   ,A.ADDR_TYPE 
                             FROM   HR_IF_PSN_ADDRESS_PRE_RCV  A
                             JOIN   HR_PSN_MST HPM
                                    ON A.SF_PERSON_ID = HPM.SF_PERSON_ID
                             WHERE  A.TRANSFER_FLAG = 'N'
                             AND    HPM.REP_COMP_CD IS NOT NULL
                             AND    A.START_DATE <= SYSDATE()
                             GROUP BY A.SF_PERSON_ID,A.ADDR_TYPE
                             ) M
                            ON  M.SF_PERSON_ID = HIPAP.SF_PERSON_ID
                            AND M.ADDR_TYPE = HIPAP.ADDR_TYPE
                            AND M.START_DATE = HIPAP.START_DATE
                     JOIN   HR_PSN_MST HPM
                            ON HIPAP.SF_PERSON_ID = HPM.SF_PERSON_ID
                     WHERE  HIPAP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_USER_ID
              ,RCV.SF_PERSON_ID
              ,RCV.SEQ_ID
              ,RCV.EMP_NO
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              -- 二쇱냼 ?뺣낫 硫붿씤
              ,RCV.ADDR_TYPE
              ,RCV.CNTRY_CD
              ,RCV.POST_CD
              ,RCV.ADDR1
              ,RCV.ADDR2
              ,RCV.ADDR3
              ,RCV.ADDR4
              ,RCV.ADDR5
              ,RCV.ADDR6
              ,RCV.ADDR7
              ,RCV.ADDR8
              ,RCV.ADDR9
              ,RCV.ADDR10
              ,RCV.DTL_ADDR1
              ,RCV.DTL_ADDR2
              ,RCV.DTL_ADDR3
              ,RCV.DTL_ADDR4
              ,RCV.DTL_ADDR5
              ,RCV.DTL_ADDR6
              ,RCV.DTL_ADDR7
              ,RCV.DTL_ADDR8
              ,RCV.DTL_ADDR9
              ,RCV.DTL_ADDR10
              ,RCV.DTL_ADDR11
              ,RCV.DTL_ADDR12
              ,RCV.DTL_ADDR13
              ,RCV.DTL_ADDR14
              ,RCV.DTL_ADDR15
              ,RCV.PROVINCE
              ,RCV.CITY
              ,RCV.STATE
              ,RCV.START_DATE
              ,CASE WHEN HPA.EMP_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.CNTRY_CD,'X') <> IFNULL(HPA.CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.POST_CD,'X') <> IFNULL(HPA.POST_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR1 , 'X') <> IFNULL(HPA.ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR2,'X') <> IFNULL(HPA.ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR3,'X') <> IFNULL(HPA.ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR4,'X') <> IFNULL(HPA.ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR5,'X') <> IFNULL(HPA.ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR6,'X') <> IFNULL(HPA.ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR7,'X') <> IFNULL(HPA.ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR8,'X') <>  IFNULL(HPA.ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR9,'X') <> IFNULL(HPA.ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR10,'X') <> IFNULL(HPA.ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR1, 'X') <> IFNULL(HPA.DTL_ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR2,'X') <> IFNULL(HPA.DTL_ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR3,'X') <> IFNULL(HPA.DTL_ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR4,'X') <> IFNULL(HPA.DTL_ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR5,'X') <> IFNULL(HPA.DTL_ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR6 ,'X') <> IFNULL(HPA.DTL_ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR7,'X') <> IFNULL(HPA.DTL_ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR8,'X') <> IFNULL(HPA.DTL_ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR9,'X') <> IFNULL(HPA.DTL_ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR10,'X') <> IFNULL(HPA.DTL_ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR11,'X') <> IFNULL(HPA.DTL_ADDR11,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR12,'X') <> IFNULL(HPA.DTL_ADDR12,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR13,'X') <> IFNULL(HPA.DTL_ADDR13,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR14,'X') <> IFNULL(HPA.DTL_ADDR14,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR15,'X') <> IFNULL(HPA.DTL_ADDR15,'X') THEN 'U'
                    WHEN IFNULL(RCV.PROVINCE,'X') <> IFNULL(HPA.PROVINCE,'X') THEN 'U'
                    WHEN IFNULL(RCV.CITY,'X') <>  IFNULL(HPA.CITY,'X') THEN 'U'
                    WHEN IFNULL(RCV.STATE,'X') <> IFNULL(HPA.STATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.START_DATE,'X') <> IFNULL(HPA.START_DATE,'X') THEN 'U'
                    ELSE 'N'
               END AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.SEQ_ID ASC) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON RCV.EMP_ID = HPM.EMP_ID
        LEFT OUTER JOIN HR_PSN_ADDRESS HPA
                        ON  RCV.EMP_ID = HPA.EMP_ID
                        AND RCV.ADDR_TYPE = HPA.ADDR_TYPE
       ) T
WHERE  ROW_NUM BETWEEN ((1 * 10000) - (10000 - 1)) AND 1 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:02:22.668669Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986108  server_id: 1710140860
# Query_time: 6.420417  Lock_time: 0.000469 Rows_sent: 10000  Rows_examined: 17949954
SET timestamp=1659520936;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_PERSON_ID
      ,T.EMP_NO
      ,T.SF_USER_ID
      ,T.PARENT_SEQ_ID
      ,T.CHILD_SEQ_ID
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      ,T.EDU_LVL_ID
      ,T.STRT_DATE
      ,T.END_DATE
      ,T.EDU_LVL_CD
      ,T.SCHL_CNTRY_CD
      ,T.SCHL_CD
      ,T.SCHL_NM
      ,T.SCHL_NM_DESC
      ,T.MAJOR_SERIES_CD
      ,T.MAJOR_SERIES_NM
      ,T.MAJOR_NM
      ,T.DBL_MAJOR_NM
      ,T.MINOR_NM
      ,T.GRADU_CD
      ,T.DGR_CD
      ,T.DGR_NO
      ,T.LST_EDU_LVL_YN
      ,T.HIRE_AFT_FLAG
      ,T.HEDU_TITLE
      ,T.DURATION_HEDU
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HPM.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,PPP.SEQ_ID AS PARENT_SEQ_ID
                           ,CCC.SEQ_ID AS CHILD_SEQ_ID
                           ,CCC.SF_KEY_ID1
                           ,PPP.SF_LST_UPDT_DT
                           -- ??숆탳 ?댁긽 ?숇젰 ?뺣낫 硫붿씤
                           ,CCC.STRT_DATE
                           ,CCC.END_DATE
                           ,'80' AS EDU_LVL_CD
                        --  ,CCC.SCHL_CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = CCC.SCHL_CNTRY_CD) AS SCHL_CNTRY_CD 
                           ,CCC.SCHL_CD
                           ,CCC.SCHL_NM
                           ,CCC.SCHL_NM_DESC
                           ,CCC.MAJOR_SERIES_CD
                           ,CCC.MAJOR_SERIES_NM
                           ,CCC.MAJOR_NM
                           ,CCC.DBL_MAJOR_NM
                           ,CCC.MINOR_NM
                           ,CCC.GRADU_CD
                           ,CCC.DGR_CD
                           ,CCC.DGR_NO
                           ,CCC.LST_EDU_LVL_YN
                           ,CCC.HIRE_AFT_FLAG
                           ,CCC.HEDU_TITLE
                           ,CCC.DURATION_HEDU
                     FROM   HR_IF_PSN_HEDU_LEVEL_P_PRE_RCV  PPP
                     JOIN   HR_IF_PSN_HEDU_LEVEL_C_PRE_RCV  CCC
                            ON  PPP.SF_USER_ID = CCC.SF_USER_ID
                            AND PPP.TRANSFER_FLAG = CCC.TRANSFER_FLAG
                     JOIN   HR_PSN_MST HPM
                            ON PPP.SF_USER_ID = HPM.SF_USER_ID
                     WHERE  PPP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
                     AND    HPM.EMP_NO IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_PERSON_ID
              ,RCV.EMP_NO
              ,RCV.SF_USER_ID
              ,RCV.PARENT_SEQ_ID
              ,RCV.CHILD_SEQ_ID
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              ,HPEL.EDU_LVL_ID
              --  ?숇젰 ?뺣낫 硫붿씤
              ,RCV.STRT_DATE
              ,RCV.END_DATE
              ,RCV.EDU_LVL_CD
              ,RCV.SCHL_CNTRY_CD
              ,RCV.SCHL_CD
              ,RCV.SCHL_NM
              ,RCV.SCHL_NM_DESC
              ,RCV.MAJOR_SERIES_CD
              ,RCV.MAJOR_SERIES_NM
              ,RCV.MAJOR_NM
              ,RCV.DBL_MAJOR_NM
              ,RCV.MINOR_NM
              ,RCV.GRADU_CD
              ,RCV.DGR_CD
              ,RCV.DGR_NO
              ,RCV.LST_EDU_LVL_YN
              ,RCV.HIRE_AFT_FLAG
              ,RCV.HEDU_TITLE
              ,RCV.DURATION_HEDU
              ,CASE WHEN HPEL.EDU_LVL_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.STRT_DATE,'X') <> IFNULL(HPEL.STRT_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.END_DATE,'X') <> IFNULL(HPEL.END_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CD,'X') <> IFNULL(HPEL.SCHL_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_NM,'X') <> IFNULL(HPEL.SCHL_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.GRADU_CD,'X') <> IFNULL(HPEL.GRADU_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.LST_EDU_LVL_YN, 'X') <> IFNULL(HPEL.LST_EDU_LVL_YN,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CNTRY_CD , 'X') <> IFNULL(HPEL.SCHL_CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_CD,'X') <> IFNULL(HPEL.MAJOR_SERIES_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_NM,'X') <> IFNULL(HPEL.MAJOR_SERIES_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_NM,'X') <> IFNULL(HPEL.MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DBL_MAJOR_NM,'X') <> IFNULL(HPEL.DBL_MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MINOR_NM,'X') <> IFNULL(HPEL.MINOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DGR_CD,'X') <> IFNULL(HPEL.DGR_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.HIRE_AFT_FLAG,'X') <> IFNULL(HPEL.HIRE_AFT_FLAG,'X') THEN 'U'
                    WHEN IFNULL(RCV.HEDU_TITLE,'X') <> IFNULL(HPEL.HEDU_TITLE,'X') THEN 'U'
                    WHEN IFNULL(RCV.DURATION_HEDU,'X') <> IFNULL(HPEL.DURATION_HEDU,'X') THEN 'U'
                    ELSE 'N'
               END  AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.parent_seq_id, RCV.child_seq_id) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON HPM.EMP_ID = RCV.EMP_ID
        LEFT OUTER JOIN HR_PSN_HEDU_LEVEL HPEL
                        ON RCV.EMP_ID = HPEL.EMP_ID
                        AND RCV.SF_KEY_ID1 = HPEL.SF_KEY_ID1) T
WHERE  ROW_NUM BETWEEN ((5 * 10000) - (10000 - 1)) AND 5 * 10000
/* [BizActor].[DAC_HR_PSN_IF_HEduLevelInfo_Adhoc].[DAS_HR_RetrieveHEduListCUN] */;
# Time: 2022-08-03T10:02:33.523034Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986108  server_id: 1710140860
# Query_time: 6.323116  Lock_time: 0.000468 Rows_sent: 10000  Rows_examined: 17949954
SET timestamp=1659520947;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_PERSON_ID
      ,T.EMP_NO
      ,T.SF_USER_ID
      ,T.PARENT_SEQ_ID
      ,T.CHILD_SEQ_ID
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      ,T.EDU_LVL_ID
      ,T.STRT_DATE
      ,T.END_DATE
      ,T.EDU_LVL_CD
      ,T.SCHL_CNTRY_CD
      ,T.SCHL_CD
      ,T.SCHL_NM
      ,T.SCHL_NM_DESC
      ,T.MAJOR_SERIES_CD
      ,T.MAJOR_SERIES_NM
      ,T.MAJOR_NM
      ,T.DBL_MAJOR_NM
      ,T.MINOR_NM
      ,T.GRADU_CD
      ,T.DGR_CD
      ,T.DGR_NO
      ,T.LST_EDU_LVL_YN
      ,T.HIRE_AFT_FLAG
      ,T.HEDU_TITLE
      ,T.DURATION_HEDU
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HPM.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,PPP.SEQ_ID AS PARENT_SEQ_ID
                           ,CCC.SEQ_ID AS CHILD_SEQ_ID
                           ,CCC.SF_KEY_ID1
                           ,PPP.SF_LST_UPDT_DT
                           -- ??숆탳 ?댁긽 ?숇젰 ?뺣낫 硫붿씤
                           ,CCC.STRT_DATE
                           ,CCC.END_DATE
                           ,'80' AS EDU_LVL_CD
                        --  ,CCC.SCHL_CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = CCC.SCHL_CNTRY_CD) AS SCHL_CNTRY_CD 
                           ,CCC.SCHL_CD
                           ,CCC.SCHL_NM
                           ,CCC.SCHL_NM_DESC
                           ,CCC.MAJOR_SERIES_CD
                           ,CCC.MAJOR_SERIES_NM
                           ,CCC.MAJOR_NM
                           ,CCC.DBL_MAJOR_NM
                           ,CCC.MINOR_NM
                           ,CCC.GRADU_CD
                           ,CCC.DGR_CD
                           ,CCC.DGR_NO
                           ,CCC.LST_EDU_LVL_YN
                           ,CCC.HIRE_AFT_FLAG
                           ,CCC.HEDU_TITLE
                           ,CCC.DURATION_HEDU
                     FROM   HR_IF_PSN_HEDU_LEVEL_P_PRE_RCV  PPP
                     JOIN   HR_IF_PSN_HEDU_LEVEL_C_PRE_RCV  CCC
                            ON  PPP.SF_USER_ID = CCC.SF_USER_ID
                            AND PPP.TRANSFER_FLAG = CCC.TRANSFER_FLAG
                     JOIN   HR_PSN_MST HPM
                            ON PPP.SF_USER_ID = HPM.SF_USER_ID
                     WHERE  PPP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
                     AND    HPM.EMP_NO IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_PERSON_ID
              ,RCV.EMP_NO
              ,RCV.SF_USER_ID
              ,RCV.PARENT_SEQ_ID
              ,RCV.CHILD_SEQ_ID
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              ,HPEL.EDU_LVL_ID
              --  ?숇젰 ?뺣낫 硫붿씤
              ,RCV.STRT_DATE
              ,RCV.END_DATE
              ,RCV.EDU_LVL_CD
              ,RCV.SCHL_CNTRY_CD
              ,RCV.SCHL_CD
              ,RCV.SCHL_NM
              ,RCV.SCHL_NM_DESC
              ,RCV.MAJOR_SERIES_CD
              ,RCV.MAJOR_SERIES_NM
              ,RCV.MAJOR_NM
              ,RCV.DBL_MAJOR_NM
              ,RCV.MINOR_NM
              ,RCV.GRADU_CD
              ,RCV.DGR_CD
              ,RCV.DGR_NO
              ,RCV.LST_EDU_LVL_YN
              ,RCV.HIRE_AFT_FLAG
              ,RCV.HEDU_TITLE
              ,RCV.DURATION_HEDU
              ,CASE WHEN HPEL.EDU_LVL_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.STRT_DATE,'X') <> IFNULL(HPEL.STRT_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.END_DATE,'X') <> IFNULL(HPEL.END_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CD,'X') <> IFNULL(HPEL.SCHL_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_NM,'X') <> IFNULL(HPEL.SCHL_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.GRADU_CD,'X') <> IFNULL(HPEL.GRADU_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.LST_EDU_LVL_YN, 'X') <> IFNULL(HPEL.LST_EDU_LVL_YN,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CNTRY_CD , 'X') <> IFNULL(HPEL.SCHL_CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_CD,'X') <> IFNULL(HPEL.MAJOR_SERIES_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_NM,'X') <> IFNULL(HPEL.MAJOR_SERIES_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_NM,'X') <> IFNULL(HPEL.MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DBL_MAJOR_NM,'X') <> IFNULL(HPEL.DBL_MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MINOR_NM,'X') <> IFNULL(HPEL.MINOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DGR_CD,'X') <> IFNULL(HPEL.DGR_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.HIRE_AFT_FLAG,'X') <> IFNULL(HPEL.HIRE_AFT_FLAG,'X') THEN 'U'
                    WHEN IFNULL(RCV.HEDU_TITLE,'X') <> IFNULL(HPEL.HEDU_TITLE,'X') THEN 'U'
                    WHEN IFNULL(RCV.DURATION_HEDU,'X') <> IFNULL(HPEL.DURATION_HEDU,'X') THEN 'U'
                    ELSE 'N'
               END  AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.parent_seq_id, RCV.child_seq_id) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON HPM.EMP_ID = RCV.EMP_ID
        LEFT OUTER JOIN HR_PSN_HEDU_LEVEL HPEL
                        ON RCV.EMP_ID = HPEL.EMP_ID
                        AND RCV.SF_KEY_ID1 = HPEL.SF_KEY_ID1) T
WHERE  ROW_NUM BETWEEN ((6 * 10000) - (10000 - 1)) AND 6 * 10000
/* [BizActor].[DAC_HR_PSN_IF_HEduLevelInfo_Adhoc].[DAS_HR_RetrieveHEduListCUN] */;
# Time: 2022-08-03T10:02:34.994099Z
# User@Host: erpapp[erpapp] @  [10.2.183.25]  thread_id: 2986125  server_id: 1710140860
# Query_time: 4.232996  Lock_time: 0.000105 Rows_sent: 0  Rows_examined: 181506
SET timestamp=1659520950;
UPDATE HR_IF_PSN_EDU_LEVEL_PRE_RCV PRE
JOIN   HR_IF_PSN_EDU_LEVEL_RCV     RCV
       ON  RCV.BATCH_ID = 1365
       AND PRE.SEQ_ID = RCV.PARENT_SEQ_ID
SET    PRE.TRANSFER_FLAG = 'Y'
      ,PRE.TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s') 
WHERE  PRE.TRANSFER_FLAG = 'N'
/* [BizActor].[DAC_HR_PSN_IF_EduLevelInfo_Adhoc].[DAS_HR_UpdateLEduPreSendFlag] */;
# Time: 2022-08-03T10:02:37.178116Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 10.226054  Lock_time: 0.001088 Rows_sent: 10000  Rows_examined: 26314240
SET timestamp=1659520946;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_USER_ID
      ,T.SF_PERSON_ID
      ,T.SEQ_ID
      ,T.EMP_NO
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      -- 二쇱냼 ?뺣낫 硫붿씤
      ,T.ADDR_TYPE
      ,T.CNTRY_CD
      ,T.POST_CD
      ,T.ADDR1
      ,T.ADDR2
      ,T.ADDR3
      ,T.ADDR4
      ,T.ADDR5
      ,T.ADDR6
      ,T.ADDR7
      ,T.ADDR8
      ,T.ADDR9
      ,T.ADDR10
      ,T.DTL_ADDR1
      ,T.DTL_ADDR2
      ,T.DTL_ADDR3
      ,T.DTL_ADDR4
      ,T.DTL_ADDR5
      ,T.DTL_ADDR6
      ,T.DTL_ADDR7
      ,T.DTL_ADDR8
      ,T.DTL_ADDR9
      ,T.DTL_ADDR10
      ,T.DTL_ADDR11
      ,T.DTL_ADDR12
      ,T.DTL_ADDR13
      ,T.DTL_ADDR14
      ,T.DTL_ADDR15
      ,T.PROVINCE
      ,T.CITY
      ,T.STATE
      ,T.START_DATE
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HIPAP.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,HIPAP.SEQ_ID
                           ,HIPAP.SF_KEY_ID1
                           ,HIPAP.SF_LST_UPDT_DT
                           -- 遺?묎?議깆젙蹂?硫붿씤
                           ,HIPAP.ADDR_TYPE
                        -- ,HIPAP.CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = HIPAP.CNTRY_CD) AS CNTRY_CD                           
                           ,HIPAP.POST_CD
                           ,IFNULL(HIPAP.ADDR1_CD,  HIPAP.ADDR1)  AS ADDR1
                           ,IFNULL(HIPAP.ADDR2_CD,  HIPAP.ADDR2)  AS ADDR2
                           ,IFNULL(HIPAP.ADDR3_CD,  HIPAP.ADDR3)  AS ADDR3
                           ,IFNULL(HIPAP.ADDR4_CD,  HIPAP.ADDR4)  AS ADDR4
                           ,IFNULL(HIPAP.ADDR5_CD,  HIPAP.ADDR5)  AS ADDR5
                           ,IFNULL(HIPAP.ADDR6_CD,  HIPAP.ADDR6)  AS ADDR6
                           ,IFNULL(HIPAP.ADDR7_CD,  HIPAP.ADDR7)  AS ADDR7
                           ,IFNULL(HIPAP.ADDR8_CD,  HIPAP.ADDR8)  AS ADDR8
                           ,IFNULL(HIPAP.ADDR9_CD,  HIPAP.ADDR9)  AS ADDR9
                           ,IFNULL(HIPAP.ADDR10_CD, HIPAP.ADDR10) AS ADDR10
                           ,IFNULL(HIPAP.ADDR11_CD, HIPAP.ADDR11) AS DTL_ADDR1
                           ,IFNULL(HIPAP.ADDR12_CD, HIPAP.ADDR12) AS DTL_ADDR2
                           ,IFNULL(HIPAP.ADDR13_CD, HIPAP.ADDR13) AS DTL_ADDR3
                           ,IFNULL(HIPAP.ADDR14_CD, HIPAP.ADDR14) AS DTL_ADDR4
                           ,IFNULL(HIPAP.ADDR15_CD, HIPAP.ADDR15) AS DTL_ADDR5
                           ,IFNULL(HIPAP.ADDR16_CD, HIPAP.ADDR16) AS DTL_ADDR6
                           ,IFNULL(HIPAP.ADDR17_CD, HIPAP.ADDR17) AS DTL_ADDR7
                           ,IFNULL(HIPAP.ADDR18_CD, HIPAP.ADDR18) AS DTL_ADDR8
                           ,IFNULL(HIPAP.ADDR19_CD, HIPAP.ADDR19) AS DTL_ADDR9
                           ,IFNULL(HIPAP.ADDR20_CD, HIPAP.ADDR20) AS DTL_ADDR10
                           ,HIPAP.CUSTOM_STRING1   AS DTL_ADDR11
                           ,HIPAP.CUSTOM_STRING2 AS DTL_ADDR12
                           ,HIPAP.CUSTOM_STRING3 AS DTL_ADDR13
                           ,HIPAP.CUSTOM_STRING4 AS DTL_ADDR14
                           ,HIPAP.CUSTOM_STRING5 AS DTL_ADDR15
                           ,IFNULL(HIPAP.PROVINCE_CD, HIPAP.PROVINCE) AS PROVINCE
                           ,IFNULL(HIPAP.CITY_CD, HIPAP.CITY) AS CITY
                           ,HIPAP.STATE
                           ,HIPAP.START_DATE
                     FROM   HR_IF_PSN_ADDRESS_PRE_RCV  HIPAP
                     JOIN   (
                             SELECT A.SF_PERSON_ID
                                   ,MAX(A.START_DATE) AS START_DATE
                                   ,A.ADDR_TYPE 
                             FROM   HR_IF_PSN_ADDRESS_PRE_RCV  A
                             JOIN   HR_PSN_MST HPM
                                    ON A.SF_PERSON_ID = HPM.SF_PERSON_ID
                             WHERE  A.TRANSFER_FLAG = 'N'
                             AND    HPM.REP_COMP_CD IS NOT NULL
                             AND    A.START_DATE <= SYSDATE()
                             GROUP BY A.SF_PERSON_ID,A.ADDR_TYPE
                             ) M
                            ON  M.SF_PERSON_ID = HIPAP.SF_PERSON_ID
                            AND M.ADDR_TYPE = HIPAP.ADDR_TYPE
                            AND M.START_DATE = HIPAP.START_DATE
                     JOIN   HR_PSN_MST HPM
                            ON HIPAP.SF_PERSON_ID = HPM.SF_PERSON_ID
                     WHERE  HIPAP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_USER_ID
              ,RCV.SF_PERSON_ID
              ,RCV.SEQ_ID
              ,RCV.EMP_NO
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              -- 二쇱냼 ?뺣낫 硫붿씤
              ,RCV.ADDR_TYPE
              ,RCV.CNTRY_CD
              ,RCV.POST_CD
              ,RCV.ADDR1
              ,RCV.ADDR2
              ,RCV.ADDR3
              ,RCV.ADDR4
              ,RCV.ADDR5
              ,RCV.ADDR6
              ,RCV.ADDR7
              ,RCV.ADDR8
              ,RCV.ADDR9
              ,RCV.ADDR10
              ,RCV.DTL_ADDR1
              ,RCV.DTL_ADDR2
              ,RCV.DTL_ADDR3
              ,RCV.DTL_ADDR4
              ,RCV.DTL_ADDR5
              ,RCV.DTL_ADDR6
              ,RCV.DTL_ADDR7
              ,RCV.DTL_ADDR8
              ,RCV.DTL_ADDR9
              ,RCV.DTL_ADDR10
              ,RCV.DTL_ADDR11
              ,RCV.DTL_ADDR12
              ,RCV.DTL_ADDR13
              ,RCV.DTL_ADDR14
              ,RCV.DTL_ADDR15
              ,RCV.PROVINCE
              ,RCV.CITY
              ,RCV.STATE
              ,RCV.START_DATE
              ,CASE WHEN HPA.EMP_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.CNTRY_CD,'X') <> IFNULL(HPA.CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.POST_CD,'X') <> IFNULL(HPA.POST_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR1 , 'X') <> IFNULL(HPA.ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR2,'X') <> IFNULL(HPA.ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR3,'X') <> IFNULL(HPA.ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR4,'X') <> IFNULL(HPA.ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR5,'X') <> IFNULL(HPA.ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR6,'X') <> IFNULL(HPA.ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR7,'X') <> IFNULL(HPA.ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR8,'X') <>  IFNULL(HPA.ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR9,'X') <> IFNULL(HPA.ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR10,'X') <> IFNULL(HPA.ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR1, 'X') <> IFNULL(HPA.DTL_ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR2,'X') <> IFNULL(HPA.DTL_ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR3,'X') <> IFNULL(HPA.DTL_ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR4,'X') <> IFNULL(HPA.DTL_ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR5,'X') <> IFNULL(HPA.DTL_ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR6 ,'X') <> IFNULL(HPA.DTL_ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR7,'X') <> IFNULL(HPA.DTL_ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR8,'X') <> IFNULL(HPA.DTL_ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR9,'X') <> IFNULL(HPA.DTL_ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR10,'X') <> IFNULL(HPA.DTL_ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR11,'X') <> IFNULL(HPA.DTL_ADDR11,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR12,'X') <> IFNULL(HPA.DTL_ADDR12,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR13,'X') <> IFNULL(HPA.DTL_ADDR13,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR14,'X') <> IFNULL(HPA.DTL_ADDR14,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR15,'X') <> IFNULL(HPA.DTL_ADDR15,'X') THEN 'U'
                    WHEN IFNULL(RCV.PROVINCE,'X') <> IFNULL(HPA.PROVINCE,'X') THEN 'U'
                    WHEN IFNULL(RCV.CITY,'X') <>  IFNULL(HPA.CITY,'X') THEN 'U'
                    WHEN IFNULL(RCV.STATE,'X') <> IFNULL(HPA.STATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.START_DATE,'X') <> IFNULL(HPA.START_DATE,'X') THEN 'U'
                    ELSE 'N'
               END AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.SEQ_ID ASC) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON RCV.EMP_ID = HPM.EMP_ID
        LEFT OUTER JOIN HR_PSN_ADDRESS HPA
                        ON  RCV.EMP_ID = HPA.EMP_ID
                        AND RCV.ADDR_TYPE = HPA.ADDR_TYPE
       ) T
WHERE  ROW_NUM BETWEEN ((2 * 10000) - (10000 - 1)) AND 2 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:02:43.824323Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986108  server_id: 1710140860
# Query_time: 6.141270  Lock_time: 0.000472 Rows_sent: 10000  Rows_examined: 17949954
SET timestamp=1659520957;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_PERSON_ID
      ,T.EMP_NO
      ,T.SF_USER_ID
      ,T.PARENT_SEQ_ID
      ,T.CHILD_SEQ_ID
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      ,T.EDU_LVL_ID
      ,T.STRT_DATE
      ,T.END_DATE
      ,T.EDU_LVL_CD
      ,T.SCHL_CNTRY_CD
      ,T.SCHL_CD
      ,T.SCHL_NM
      ,T.SCHL_NM_DESC
      ,T.MAJOR_SERIES_CD
      ,T.MAJOR_SERIES_NM
      ,T.MAJOR_NM
      ,T.DBL_MAJOR_NM
      ,T.MINOR_NM
      ,T.GRADU_CD
      ,T.DGR_CD
      ,T.DGR_NO
      ,T.LST_EDU_LVL_YN
      ,T.HIRE_AFT_FLAG
      ,T.HEDU_TITLE
      ,T.DURATION_HEDU
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HPM.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,PPP.SEQ_ID AS PARENT_SEQ_ID
                           ,CCC.SEQ_ID AS CHILD_SEQ_ID
                           ,CCC.SF_KEY_ID1
                           ,PPP.SF_LST_UPDT_DT
                           -- ??숆탳 ?댁긽 ?숇젰 ?뺣낫 硫붿씤
                           ,CCC.STRT_DATE
                           ,CCC.END_DATE
                           ,'80' AS EDU_LVL_CD
                        --  ,CCC.SCHL_CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = CCC.SCHL_CNTRY_CD) AS SCHL_CNTRY_CD 
                           ,CCC.SCHL_CD
                           ,CCC.SCHL_NM
                           ,CCC.SCHL_NM_DESC
                           ,CCC.MAJOR_SERIES_CD
                           ,CCC.MAJOR_SERIES_NM
                           ,CCC.MAJOR_NM
                           ,CCC.DBL_MAJOR_NM
                           ,CCC.MINOR_NM
                           ,CCC.GRADU_CD
                           ,CCC.DGR_CD
                           ,CCC.DGR_NO
                           ,CCC.LST_EDU_LVL_YN
                           ,CCC.HIRE_AFT_FLAG
                           ,CCC.HEDU_TITLE
                           ,CCC.DURATION_HEDU
                     FROM   HR_IF_PSN_HEDU_LEVEL_P_PRE_RCV  PPP
                     JOIN   HR_IF_PSN_HEDU_LEVEL_C_PRE_RCV  CCC
                            ON  PPP.SF_USER_ID = CCC.SF_USER_ID
                            AND PPP.TRANSFER_FLAG = CCC.TRANSFER_FLAG
                     JOIN   HR_PSN_MST HPM
                            ON PPP.SF_USER_ID = HPM.SF_USER_ID
                     WHERE  PPP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
                     AND    HPM.EMP_NO IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_PERSON_ID
              ,RCV.EMP_NO
              ,RCV.SF_USER_ID
              ,RCV.PARENT_SEQ_ID
              ,RCV.CHILD_SEQ_ID
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              ,HPEL.EDU_LVL_ID
              --  ?숇젰 ?뺣낫 硫붿씤
              ,RCV.STRT_DATE
              ,RCV.END_DATE
              ,RCV.EDU_LVL_CD
              ,RCV.SCHL_CNTRY_CD
              ,RCV.SCHL_CD
              ,RCV.SCHL_NM
              ,RCV.SCHL_NM_DESC
              ,RCV.MAJOR_SERIES_CD
              ,RCV.MAJOR_SERIES_NM
              ,RCV.MAJOR_NM
              ,RCV.DBL_MAJOR_NM
              ,RCV.MINOR_NM
              ,RCV.GRADU_CD
              ,RCV.DGR_CD
              ,RCV.DGR_NO
              ,RCV.LST_EDU_LVL_YN
              ,RCV.HIRE_AFT_FLAG
              ,RCV.HEDU_TITLE
              ,RCV.DURATION_HEDU
              ,CASE WHEN HPEL.EDU_LVL_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.STRT_DATE,'X') <> IFNULL(HPEL.STRT_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.END_DATE,'X') <> IFNULL(HPEL.END_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CD,'X') <> IFNULL(HPEL.SCHL_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_NM,'X') <> IFNULL(HPEL.SCHL_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.GRADU_CD,'X') <> IFNULL(HPEL.GRADU_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.LST_EDU_LVL_YN, 'X') <> IFNULL(HPEL.LST_EDU_LVL_YN,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CNTRY_CD , 'X') <> IFNULL(HPEL.SCHL_CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_CD,'X') <> IFNULL(HPEL.MAJOR_SERIES_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_NM,'X') <> IFNULL(HPEL.MAJOR_SERIES_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_NM,'X') <> IFNULL(HPEL.MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DBL_MAJOR_NM,'X') <> IFNULL(HPEL.DBL_MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MINOR_NM,'X') <> IFNULL(HPEL.MINOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DGR_CD,'X') <> IFNULL(HPEL.DGR_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.HIRE_AFT_FLAG,'X') <> IFNULL(HPEL.HIRE_AFT_FLAG,'X') THEN 'U'
                    WHEN IFNULL(RCV.HEDU_TITLE,'X') <> IFNULL(HPEL.HEDU_TITLE,'X') THEN 'U'
                    WHEN IFNULL(RCV.DURATION_HEDU,'X') <> IFNULL(HPEL.DURATION_HEDU,'X') THEN 'U'
                    ELSE 'N'
               END  AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.parent_seq_id, RCV.child_seq_id) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON HPM.EMP_ID = RCV.EMP_ID
        LEFT OUTER JOIN HR_PSN_HEDU_LEVEL HPEL
                        ON RCV.EMP_ID = HPEL.EMP_ID
                        AND RCV.SF_KEY_ID1 = HPEL.SF_KEY_ID1) T
WHERE  ROW_NUM BETWEEN ((7 * 10000) - (10000 - 1)) AND 7 * 10000
/* [BizActor].[DAC_HR_PSN_IF_HEduLevelInfo_Adhoc].[DAS_HR_RetrieveHEduListCUN] */;
# Time: 2022-08-03T10:02:44.741540Z
# User@Host: erpapp[erpapp] @  [10.2.183.25]  thread_id: 2986124  server_id: 1710140860
# Query_time: 4.760892  Lock_time: 0.000097 Rows_sent: 0  Rows_examined: 203118
SET timestamp=1659520959;
UPDATE HR_IF_PSN_FLANG_C_PRE_RCV PRE
JOIN   HR_IF_PSN_FLANG_RCV       RCV
       ON  RCV.BATCH_ID = 1364
       AND PRE.SEQ_ID = RCV.CHILD_SEQ_ID
SET    PRE.TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
      ,PRE.TRANSFER_FLAG = 'Y'
WHERE  PRE.TRANSFER_FLAG = 'N'
/* [BizActor].[DAC_HR_PSN_IF_FlangInfo_Adhoc].[DAS_HR_UpdateFlangCPreTransferFlag] */;
# Time: 2022-08-03T10:02:52.115487Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 9.998990  Lock_time: 0.000699 Rows_sent: 10000  Rows_examined: 26314240
SET timestamp=1659520962;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_USER_ID
      ,T.SF_PERSON_ID
      ,T.SEQ_ID
      ,T.EMP_NO
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      -- 二쇱냼 ?뺣낫 硫붿씤
      ,T.ADDR_TYPE
      ,T.CNTRY_CD
      ,T.POST_CD
      ,T.ADDR1
      ,T.ADDR2
      ,T.ADDR3
      ,T.ADDR4
      ,T.ADDR5
      ,T.ADDR6
      ,T.ADDR7
      ,T.ADDR8
      ,T.ADDR9
      ,T.ADDR10
      ,T.DTL_ADDR1
      ,T.DTL_ADDR2
      ,T.DTL_ADDR3
      ,T.DTL_ADDR4
      ,T.DTL_ADDR5
      ,T.DTL_ADDR6
      ,T.DTL_ADDR7
      ,T.DTL_ADDR8
      ,T.DTL_ADDR9
      ,T.DTL_ADDR10
      ,T.DTL_ADDR11
      ,T.DTL_ADDR12
      ,T.DTL_ADDR13
      ,T.DTL_ADDR14
      ,T.DTL_ADDR15
      ,T.PROVINCE
      ,T.CITY
      ,T.STATE
      ,T.START_DATE
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HIPAP.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,HIPAP.SEQ_ID
                           ,HIPAP.SF_KEY_ID1
                           ,HIPAP.SF_LST_UPDT_DT
                           -- 遺?묎?議깆젙蹂?硫붿씤
                           ,HIPAP.ADDR_TYPE
                        -- ,HIPAP.CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = HIPAP.CNTRY_CD) AS CNTRY_CD                           
                           ,HIPAP.POST_CD
                           ,IFNULL(HIPAP.ADDR1_CD,  HIPAP.ADDR1)  AS ADDR1
                           ,IFNULL(HIPAP.ADDR2_CD,  HIPAP.ADDR2)  AS ADDR2
                           ,IFNULL(HIPAP.ADDR3_CD,  HIPAP.ADDR3)  AS ADDR3
                           ,IFNULL(HIPAP.ADDR4_CD,  HIPAP.ADDR4)  AS ADDR4
                           ,IFNULL(HIPAP.ADDR5_CD,  HIPAP.ADDR5)  AS ADDR5
                           ,IFNULL(HIPAP.ADDR6_CD,  HIPAP.ADDR6)  AS ADDR6
                           ,IFNULL(HIPAP.ADDR7_CD,  HIPAP.ADDR7)  AS ADDR7
                           ,IFNULL(HIPAP.ADDR8_CD,  HIPAP.ADDR8)  AS ADDR8
                           ,IFNULL(HIPAP.ADDR9_CD,  HIPAP.ADDR9)  AS ADDR9
                           ,IFNULL(HIPAP.ADDR10_CD, HIPAP.ADDR10) AS ADDR10
                           ,IFNULL(HIPAP.ADDR11_CD, HIPAP.ADDR11) AS DTL_ADDR1
                           ,IFNULL(HIPAP.ADDR12_CD, HIPAP.ADDR12) AS DTL_ADDR2
                           ,IFNULL(HIPAP.ADDR13_CD, HIPAP.ADDR13) AS DTL_ADDR3
                           ,IFNULL(HIPAP.ADDR14_CD, HIPAP.ADDR14) AS DTL_ADDR4
                           ,IFNULL(HIPAP.ADDR15_CD, HIPAP.ADDR15) AS DTL_ADDR5
                           ,IFNULL(HIPAP.ADDR16_CD, HIPAP.ADDR16) AS DTL_ADDR6
                           ,IFNULL(HIPAP.ADDR17_CD, HIPAP.ADDR17) AS DTL_ADDR7
                           ,IFNULL(HIPAP.ADDR18_CD, HIPAP.ADDR18) AS DTL_ADDR8
                           ,IFNULL(HIPAP.ADDR19_CD, HIPAP.ADDR19) AS DTL_ADDR9
                           ,IFNULL(HIPAP.ADDR20_CD, HIPAP.ADDR20) AS DTL_ADDR10
                           ,HIPAP.CUSTOM_STRING1   AS DTL_ADDR11
                           ,HIPAP.CUSTOM_STRING2 AS DTL_ADDR12
                           ,HIPAP.CUSTOM_STRING3 AS DTL_ADDR13
                           ,HIPAP.CUSTOM_STRING4 AS DTL_ADDR14
                           ,HIPAP.CUSTOM_STRING5 AS DTL_ADDR15
                           ,IFNULL(HIPAP.PROVINCE_CD, HIPAP.PROVINCE) AS PROVINCE
                           ,IFNULL(HIPAP.CITY_CD, HIPAP.CITY) AS CITY
                           ,HIPAP.STATE
                           ,HIPAP.START_DATE
                     FROM   HR_IF_PSN_ADDRESS_PRE_RCV  HIPAP
                     JOIN   (
                             SELECT A.SF_PERSON_ID
                                   ,MAX(A.START_DATE) AS START_DATE
                                   ,A.ADDR_TYPE 
                             FROM   HR_IF_PSN_ADDRESS_PRE_RCV  A
                             JOIN   HR_PSN_MST HPM
                                    ON A.SF_PERSON_ID = HPM.SF_PERSON_ID
                             WHERE  A.TRANSFER_FLAG = 'N'
                             AND    HPM.REP_COMP_CD IS NOT NULL
                             AND    A.START_DATE <= SYSDATE()
                             GROUP BY A.SF_PERSON_ID,A.ADDR_TYPE
                             ) M
                            ON  M.SF_PERSON_ID = HIPAP.SF_PERSON_ID
                            AND M.ADDR_TYPE = HIPAP.ADDR_TYPE
                            AND M.START_DATE = HIPAP.START_DATE
                     JOIN   HR_PSN_MST HPM
                            ON HIPAP.SF_PERSON_ID = HPM.SF_PERSON_ID
                     WHERE  HIPAP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_USER_ID
              ,RCV.SF_PERSON_ID
              ,RCV.SEQ_ID
              ,RCV.EMP_NO
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              -- 二쇱냼 ?뺣낫 硫붿씤
              ,RCV.ADDR_TYPE
              ,RCV.CNTRY_CD
              ,RCV.POST_CD
              ,RCV.ADDR1
              ,RCV.ADDR2
              ,RCV.ADDR3
              ,RCV.ADDR4
              ,RCV.ADDR5
              ,RCV.ADDR6
              ,RCV.ADDR7
              ,RCV.ADDR8
              ,RCV.ADDR9
              ,RCV.ADDR10
              ,RCV.DTL_ADDR1
              ,RCV.DTL_ADDR2
              ,RCV.DTL_ADDR3
              ,RCV.DTL_ADDR4
              ,RCV.DTL_ADDR5
              ,RCV.DTL_ADDR6
              ,RCV.DTL_ADDR7
              ,RCV.DTL_ADDR8
              ,RCV.DTL_ADDR9
              ,RCV.DTL_ADDR10
              ,RCV.DTL_ADDR11
              ,RCV.DTL_ADDR12
              ,RCV.DTL_ADDR13
              ,RCV.DTL_ADDR14
              ,RCV.DTL_ADDR15
              ,RCV.PROVINCE
              ,RCV.CITY
              ,RCV.STATE
              ,RCV.START_DATE
              ,CASE WHEN HPA.EMP_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.CNTRY_CD,'X') <> IFNULL(HPA.CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.POST_CD,'X') <> IFNULL(HPA.POST_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR1 , 'X') <> IFNULL(HPA.ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR2,'X') <> IFNULL(HPA.ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR3,'X') <> IFNULL(HPA.ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR4,'X') <> IFNULL(HPA.ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR5,'X') <> IFNULL(HPA.ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR6,'X') <> IFNULL(HPA.ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR7,'X') <> IFNULL(HPA.ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR8,'X') <>  IFNULL(HPA.ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR9,'X') <> IFNULL(HPA.ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR10,'X') <> IFNULL(HPA.ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR1, 'X') <> IFNULL(HPA.DTL_ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR2,'X') <> IFNULL(HPA.DTL_ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR3,'X') <> IFNULL(HPA.DTL_ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR4,'X') <> IFNULL(HPA.DTL_ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR5,'X') <> IFNULL(HPA.DTL_ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR6 ,'X') <> IFNULL(HPA.DTL_ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR7,'X') <> IFNULL(HPA.DTL_ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR8,'X') <> IFNULL(HPA.DTL_ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR9,'X') <> IFNULL(HPA.DTL_ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR10,'X') <> IFNULL(HPA.DTL_ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR11,'X') <> IFNULL(HPA.DTL_ADDR11,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR12,'X') <> IFNULL(HPA.DTL_ADDR12,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR13,'X') <> IFNULL(HPA.DTL_ADDR13,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR14,'X') <> IFNULL(HPA.DTL_ADDR14,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR15,'X') <> IFNULL(HPA.DTL_ADDR15,'X') THEN 'U'
                    WHEN IFNULL(RCV.PROVINCE,'X') <> IFNULL(HPA.PROVINCE,'X') THEN 'U'
                    WHEN IFNULL(RCV.CITY,'X') <>  IFNULL(HPA.CITY,'X') THEN 'U'
                    WHEN IFNULL(RCV.STATE,'X') <> IFNULL(HPA.STATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.START_DATE,'X') <> IFNULL(HPA.START_DATE,'X') THEN 'U'
                    ELSE 'N'
               END AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.SEQ_ID ASC) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON RCV.EMP_ID = HPM.EMP_ID
        LEFT OUTER JOIN HR_PSN_ADDRESS HPA
                        ON  RCV.EMP_ID = HPA.EMP_ID
                        AND RCV.ADDR_TYPE = HPA.ADDR_TYPE
       ) T
WHERE  ROW_NUM BETWEEN ((3 * 10000) - (10000 - 1)) AND 3 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:02:53.746100Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986108  server_id: 1710140860
# Query_time: 6.286186  Lock_time: 0.000463 Rows_sent: 119  Rows_examined: 17949954
SET timestamp=1659520967;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_PERSON_ID
      ,T.EMP_NO
      ,T.SF_USER_ID
      ,T.PARENT_SEQ_ID
      ,T.CHILD_SEQ_ID
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      ,T.EDU_LVL_ID
      ,T.STRT_DATE
      ,T.END_DATE
      ,T.EDU_LVL_CD
      ,T.SCHL_CNTRY_CD
      ,T.SCHL_CD
      ,T.SCHL_NM
      ,T.SCHL_NM_DESC
      ,T.MAJOR_SERIES_CD
      ,T.MAJOR_SERIES_NM
      ,T.MAJOR_NM
      ,T.DBL_MAJOR_NM
      ,T.MINOR_NM
      ,T.GRADU_CD
      ,T.DGR_CD
      ,T.DGR_NO
      ,T.LST_EDU_LVL_YN
      ,T.HIRE_AFT_FLAG
      ,T.HEDU_TITLE
      ,T.DURATION_HEDU
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HPM.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,PPP.SEQ_ID AS PARENT_SEQ_ID
                           ,CCC.SEQ_ID AS CHILD_SEQ_ID
                           ,CCC.SF_KEY_ID1
                           ,PPP.SF_LST_UPDT_DT
                           -- ??숆탳 ?댁긽 ?숇젰 ?뺣낫 硫붿씤
                           ,CCC.STRT_DATE
                           ,CCC.END_DATE
                           ,'80' AS EDU_LVL_CD
                        --  ,CCC.SCHL_CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = CCC.SCHL_CNTRY_CD) AS SCHL_CNTRY_CD 
                           ,CCC.SCHL_CD
                           ,CCC.SCHL_NM
                           ,CCC.SCHL_NM_DESC
                           ,CCC.MAJOR_SERIES_CD
                           ,CCC.MAJOR_SERIES_NM
                           ,CCC.MAJOR_NM
                           ,CCC.DBL_MAJOR_NM
                           ,CCC.MINOR_NM
                           ,CCC.GRADU_CD
                           ,CCC.DGR_CD
                           ,CCC.DGR_NO
                           ,CCC.LST_EDU_LVL_YN
                           ,CCC.HIRE_AFT_FLAG
                           ,CCC.HEDU_TITLE
                           ,CCC.DURATION_HEDU
                     FROM   HR_IF_PSN_HEDU_LEVEL_P_PRE_RCV  PPP
                     JOIN   HR_IF_PSN_HEDU_LEVEL_C_PRE_RCV  CCC
                            ON  PPP.SF_USER_ID = CCC.SF_USER_ID
                            AND PPP.TRANSFER_FLAG = CCC.TRANSFER_FLAG
                     JOIN   HR_PSN_MST HPM
                            ON PPP.SF_USER_ID = HPM.SF_USER_ID
                     WHERE  PPP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
                     AND    HPM.EMP_NO IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_PERSON_ID
              ,RCV.EMP_NO
              ,RCV.SF_USER_ID
              ,RCV.PARENT_SEQ_ID
              ,RCV.CHILD_SEQ_ID
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              ,HPEL.EDU_LVL_ID
              --  ?숇젰 ?뺣낫 硫붿씤
              ,RCV.STRT_DATE
              ,RCV.END_DATE
              ,RCV.EDU_LVL_CD
              ,RCV.SCHL_CNTRY_CD
              ,RCV.SCHL_CD
              ,RCV.SCHL_NM
              ,RCV.SCHL_NM_DESC
              ,RCV.MAJOR_SERIES_CD
              ,RCV.MAJOR_SERIES_NM
              ,RCV.MAJOR_NM
              ,RCV.DBL_MAJOR_NM
              ,RCV.MINOR_NM
              ,RCV.GRADU_CD
              ,RCV.DGR_CD
              ,RCV.DGR_NO
              ,RCV.LST_EDU_LVL_YN
              ,RCV.HIRE_AFT_FLAG
              ,RCV.HEDU_TITLE
              ,RCV.DURATION_HEDU
              ,CASE WHEN HPEL.EDU_LVL_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.STRT_DATE,'X') <> IFNULL(HPEL.STRT_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.END_DATE,'X') <> IFNULL(HPEL.END_DATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CD,'X') <> IFNULL(HPEL.SCHL_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_NM,'X') <> IFNULL(HPEL.SCHL_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.GRADU_CD,'X') <> IFNULL(HPEL.GRADU_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.LST_EDU_LVL_YN, 'X') <> IFNULL(HPEL.LST_EDU_LVL_YN,'X') THEN 'U'
                    WHEN IFNULL(RCV.SCHL_CNTRY_CD , 'X') <> IFNULL(HPEL.SCHL_CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_CD,'X') <> IFNULL(HPEL.MAJOR_SERIES_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_SERIES_NM,'X') <> IFNULL(HPEL.MAJOR_SERIES_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MAJOR_NM,'X') <> IFNULL(HPEL.MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DBL_MAJOR_NM,'X') <> IFNULL(HPEL.DBL_MAJOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.MINOR_NM,'X') <> IFNULL(HPEL.MINOR_NM,'X') THEN 'U'
                    WHEN IFNULL(RCV.DGR_CD,'X') <> IFNULL(HPEL.DGR_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.HIRE_AFT_FLAG,'X') <> IFNULL(HPEL.HIRE_AFT_FLAG,'X') THEN 'U'
                    WHEN IFNULL(RCV.HEDU_TITLE,'X') <> IFNULL(HPEL.HEDU_TITLE,'X') THEN 'U'
                    WHEN IFNULL(RCV.DURATION_HEDU,'X') <> IFNULL(HPEL.DURATION_HEDU,'X') THEN 'U'
                    ELSE 'N'
               END  AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.parent_seq_id, RCV.child_seq_id) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON HPM.EMP_ID = RCV.EMP_ID
        LEFT OUTER JOIN HR_PSN_HEDU_LEVEL HPEL
                        ON RCV.EMP_ID = HPEL.EMP_ID
                        AND RCV.SF_KEY_ID1 = HPEL.SF_KEY_ID1) T
WHERE  ROW_NUM BETWEEN ((8 * 10000) - (10000 - 1)) AND 8 * 10000
/* [BizActor].[DAC_HR_PSN_IF_HEduLevelInfo_Adhoc].[DAS_HR_RetrieveHEduListCUN] */;
# Time: 2022-08-03T10:02:59.487574Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986108  server_id: 1710140860
# Query_time: 5.688591  Lock_time: 0.000382 Rows_sent: 5  Rows_examined: 17879840
SET timestamp=1659520973;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_PERSON_ID
      ,T.EMP_NO
      ,T.SF_USER_ID
      ,T.PARENT_SEQ_ID
      ,T.CHILD_SEQ_ID
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      ,T.EDU_LVL_ID
      ,T.STRT_DATE
      ,T.END_DATE
      ,T.EDU_LVL_CD
      ,T.SCHL_CNTRY_CD
      ,T.SCHL_CD
      ,T.SCHL_NM
      ,T.SCHL_NM_DESC
      ,T.MAJOR_SERIES_CD
      ,T.MAJOR_SERIES_NM
      ,T.MAJOR_NM
      ,T.DBL_MAJOR_NM
      ,T.MINOR_NM
      ,T.GRADU_CD
      ,T.DGR_CD
      ,T.DGR_NO
      ,T.LST_EDU_LVL_YN
      ,T.HIRE_AFT_FLAG
      ,T.HEDU_TITLE
      ,T.DURATION_HEDU
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HPM.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,PPP.SEQ_ID AS PARENT_SEQ_ID
                           ,CCC.SEQ_ID AS CHILD_SEQ_ID
                           ,CCC.SF_KEY_ID1
                           ,PPP.SF_LST_UPDT_DT
                           -- ??숆탳 ?댁긽 ?숇젰 ?뺣낫 硫붿씤
                           ,CCC.STRT_DATE
                           ,CCC.END_DATE
                           ,'80' AS EDU_LVL_CD
                         --  ,CCC.SCHL_CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = CCC.SCHL_CNTRY_CD) AS SCHL_CNTRY_CD                          
                           ,CCC.SCHL_CD
                           ,CCC.SCHL_NM
                           ,CCC.SCHL_NM_DESC
                           ,CCC.MAJOR_SERIES_CD
                           ,CCC.MAJOR_SERIES_NM
                           ,CCC.MAJOR_NM
                           ,CCC.DBL_MAJOR_NM
                           ,CCC.MINOR_NM
                           ,CCC.GRADU_CD
                           ,CCC.DGR_CD
                           ,CCC.DGR_NO
                           ,CCC.LST_EDU_LVL_YN
                           ,CCC.HIRE_AFT_FLAG
                           ,CCC.HEDU_TITLE
                           ,CCC.DURATION_HEDU
                     FROM   HR_IF_PSN_HEDU_LEVEL_P_PRE_RCV  PPP
                     JOIN   HR_IF_PSN_HEDU_LEVEL_C_PRE_RCV  CCC
                            ON  PPP.SF_USER_ID = CCC.SF_USER_ID
                            AND PPP.TRANSFER_FLAG = CCC.TRANSFER_FLAG
                     JOIN   HR_PSN_MST HPM
                            ON PPP.SF_USER_ID = HPM.SF_USER_ID
                     WHERE  PPP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
                     AND    HPM.EMP_NO IS NOT NULL
/*                     
WHERE */
)
        SELECT HPEL.REP_COMP_CD
              ,HPEL.COMP_CD
              ,HPEL.EMP_ID
              ,HPEL.SF_PERSON_ID
              ,HPM.EMP_NO
              ,HPEL.SF_USER_ID
              ,0 AS PARENT_SEQ_ID
              ,0 AS CHILD_SEQ_ID
              ,HPEL.SF_KEY_ID1
              ,HPEL.SF_LST_UPDT_DT
              ,HPEL.EDU_LVL_ID
              --  ?숇젰 ?뺣낫 硫붿씤
              ,HPEL.STRT_DATE
              ,HPEL.END_DATE
              ,HPEL.EDU_LVL_CD
              ,HPEL.SCHL_CNTRY_CD
              ,HPEL.SCHL_CD
              ,HPEL.SCHL_NM
              ,HPEL.SCHL_NM_DESC
              ,HPEL.MAJOR_SERIES_CD
              ,HPEL.MAJOR_SERIES_NM
              ,HPEL.MAJOR_NM
              ,HPEL.DBL_MAJOR_NM
              ,HPEL.MINOR_NM
              ,HPEL.GRADU_CD
              ,HPEL.DGR_CD
              ,HPEL.DGR_NO
              ,HPEL.LST_EDU_LVL_YN
              ,HPEL.HIRE_AFT_FLAG
              ,HPEL.HEDU_TITLE
              ,HPEL.DURATION_HEDU
              ,'D' AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY HPEL.EDU_LVL_ID) AS ROW_NUM
        FROM   HR_PSN_HEDU_LEVEL HPEL 
        JOIN   HR_PSN_MST HPM
               ON HPEL.EMP_ID = HPM.EMP_ID
        WHERE  NOT EXISTS (SELECT 1 
                           FROM   RCV R
                           WHERE  R.EMP_ID = HPEL.EMP_ID
                           AND    R.SF_KEY_ID1 = HPEL.SF_KEY_ID1)
        AND    HPM.REP_COMP_CD IS NOT NULL
        AND    HPM.COMP_CD IS NOT NULL
/*        
AND */
) T
WHERE  ROW_NUM BETWEEN ((1 * 10000) - (10000 - 1)) AND 1 * 10000
/* [BizActor].[DAC_HR_PSN_IF_HEduLevelInfo_Adhoc].[DAS_HR_RetrieveHEduListD] */;
# Time: 2022-08-03T10:03:05.608286Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986108  server_id: 1710140860
# Query_time: 4.150409  Lock_time: 0.000140 Rows_sent: 0  Rows_examined: 140243
SET timestamp=1659520981;
UPDATE HR_IF_PSN_HEDU_LEVEL_C_PRE_RCV PRE
JOIN   HR_IF_PSN_HEDU_LEVEL_RCV       RCV
       ON RCV.BATCH_ID = 1363
       AND PRE.SEQ_ID = RCV.CHILD_SEQ_ID
SET    PRE.TRANSFER_FLAG = 'Y'
      ,PRE.TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
WHERE  PRE.TRANSFER_FLAG = 'N'
/* [BizActor].[DAC_HR_PSN_IF_HEduLevelInfo_Adhoc].[DAS_HR_UpdateEduLevelCPreTransferFlag] */;
# Time: 2022-08-03T10:03:06.661316Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 10.038710  Lock_time: 0.000796 Rows_sent: 10000  Rows_examined: 26314240
SET timestamp=1659520976;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_USER_ID
      ,T.SF_PERSON_ID
      ,T.SEQ_ID
      ,T.EMP_NO
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      -- 二쇱냼 ?뺣낫 硫붿씤
      ,T.ADDR_TYPE
      ,T.CNTRY_CD
      ,T.POST_CD
      ,T.ADDR1
      ,T.ADDR2
      ,T.ADDR3
      ,T.ADDR4
      ,T.ADDR5
      ,T.ADDR6
      ,T.ADDR7
      ,T.ADDR8
      ,T.ADDR9
      ,T.ADDR10
      ,T.DTL_ADDR1
      ,T.DTL_ADDR2
      ,T.DTL_ADDR3
      ,T.DTL_ADDR4
      ,T.DTL_ADDR5
      ,T.DTL_ADDR6
      ,T.DTL_ADDR7
      ,T.DTL_ADDR8
      ,T.DTL_ADDR9
      ,T.DTL_ADDR10
      ,T.DTL_ADDR11
      ,T.DTL_ADDR12
      ,T.DTL_ADDR13
      ,T.DTL_ADDR14
      ,T.DTL_ADDR15
      ,T.PROVINCE
      ,T.CITY
      ,T.STATE
      ,T.START_DATE
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HIPAP.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,HIPAP.SEQ_ID
                           ,HIPAP.SF_KEY_ID1
                           ,HIPAP.SF_LST_UPDT_DT
                           -- 遺?묎?議깆젙蹂?硫붿씤
                           ,HIPAP.ADDR_TYPE
                        -- ,HIPAP.CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = HIPAP.CNTRY_CD) AS CNTRY_CD                           
                           ,HIPAP.POST_CD
                           ,IFNULL(HIPAP.ADDR1_CD,  HIPAP.ADDR1)  AS ADDR1
                           ,IFNULL(HIPAP.ADDR2_CD,  HIPAP.ADDR2)  AS ADDR2
                           ,IFNULL(HIPAP.ADDR3_CD,  HIPAP.ADDR3)  AS ADDR3
                           ,IFNULL(HIPAP.ADDR4_CD,  HIPAP.ADDR4)  AS ADDR4
                           ,IFNULL(HIPAP.ADDR5_CD,  HIPAP.ADDR5)  AS ADDR5
                           ,IFNULL(HIPAP.ADDR6_CD,  HIPAP.ADDR6)  AS ADDR6
                           ,IFNULL(HIPAP.ADDR7_CD,  HIPAP.ADDR7)  AS ADDR7
                           ,IFNULL(HIPAP.ADDR8_CD,  HIPAP.ADDR8)  AS ADDR8
                           ,IFNULL(HIPAP.ADDR9_CD,  HIPAP.ADDR9)  AS ADDR9
                           ,IFNULL(HIPAP.ADDR10_CD, HIPAP.ADDR10) AS ADDR10
                           ,IFNULL(HIPAP.ADDR11_CD, HIPAP.ADDR11) AS DTL_ADDR1
                           ,IFNULL(HIPAP.ADDR12_CD, HIPAP.ADDR12) AS DTL_ADDR2
                           ,IFNULL(HIPAP.ADDR13_CD, HIPAP.ADDR13) AS DTL_ADDR3
                           ,IFNULL(HIPAP.ADDR14_CD, HIPAP.ADDR14) AS DTL_ADDR4
                           ,IFNULL(HIPAP.ADDR15_CD, HIPAP.ADDR15) AS DTL_ADDR5
                           ,IFNULL(HIPAP.ADDR16_CD, HIPAP.ADDR16) AS DTL_ADDR6
                           ,IFNULL(HIPAP.ADDR17_CD, HIPAP.ADDR17) AS DTL_ADDR7
                           ,IFNULL(HIPAP.ADDR18_CD, HIPAP.ADDR18) AS DTL_ADDR8
                           ,IFNULL(HIPAP.ADDR19_CD, HIPAP.ADDR19) AS DTL_ADDR9
                           ,IFNULL(HIPAP.ADDR20_CD, HIPAP.ADDR20) AS DTL_ADDR10
                           ,HIPAP.CUSTOM_STRING1   AS DTL_ADDR11
                           ,HIPAP.CUSTOM_STRING2 AS DTL_ADDR12
                           ,HIPAP.CUSTOM_STRING3 AS DTL_ADDR13
                           ,HIPAP.CUSTOM_STRING4 AS DTL_ADDR14
                           ,HIPAP.CUSTOM_STRING5 AS DTL_ADDR15
                           ,IFNULL(HIPAP.PROVINCE_CD, HIPAP.PROVINCE) AS PROVINCE
                           ,IFNULL(HIPAP.CITY_CD, HIPAP.CITY) AS CITY
                           ,HIPAP.STATE
                           ,HIPAP.START_DATE
                     FROM   HR_IF_PSN_ADDRESS_PRE_RCV  HIPAP
                     JOIN   (
                             SELECT A.SF_PERSON_ID
                                   ,MAX(A.START_DATE) AS START_DATE
                                   ,A.ADDR_TYPE 
                             FROM   HR_IF_PSN_ADDRESS_PRE_RCV  A
                             JOIN   HR_PSN_MST HPM
                                    ON A.SF_PERSON_ID = HPM.SF_PERSON_ID
                             WHERE  A.TRANSFER_FLAG = 'N'
                             AND    HPM.REP_COMP_CD IS NOT NULL
                             AND    A.START_DATE <= SYSDATE()
                             GROUP BY A.SF_PERSON_ID,A.ADDR_TYPE
                             ) M
                            ON  M.SF_PERSON_ID = HIPAP.SF_PERSON_ID
                            AND M.ADDR_TYPE = HIPAP.ADDR_TYPE
                            AND M.START_DATE = HIPAP.START_DATE
                     JOIN   HR_PSN_MST HPM
                            ON HIPAP.SF_PERSON_ID = HPM.SF_PERSON_ID
                     WHERE  HIPAP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_USER_ID
              ,RCV.SF_PERSON_ID
              ,RCV.SEQ_ID
              ,RCV.EMP_NO
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              -- 二쇱냼 ?뺣낫 硫붿씤
              ,RCV.ADDR_TYPE
              ,RCV.CNTRY_CD
              ,RCV.POST_CD
              ,RCV.ADDR1
              ,RCV.ADDR2
              ,RCV.ADDR3
              ,RCV.ADDR4
              ,RCV.ADDR5
              ,RCV.ADDR6
              ,RCV.ADDR7
              ,RCV.ADDR8
              ,RCV.ADDR9
              ,RCV.ADDR10
              ,RCV.DTL_ADDR1
              ,RCV.DTL_ADDR2
              ,RCV.DTL_ADDR3
              ,RCV.DTL_ADDR4
              ,RCV.DTL_ADDR5
              ,RCV.DTL_ADDR6
              ,RCV.DTL_ADDR7
              ,RCV.DTL_ADDR8
              ,RCV.DTL_ADDR9
              ,RCV.DTL_ADDR10
              ,RCV.DTL_ADDR11
              ,RCV.DTL_ADDR12
              ,RCV.DTL_ADDR13
              ,RCV.DTL_ADDR14
              ,RCV.DTL_ADDR15
              ,RCV.PROVINCE
              ,RCV.CITY
              ,RCV.STATE
              ,RCV.START_DATE
              ,CASE WHEN HPA.EMP_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.CNTRY_CD,'X') <> IFNULL(HPA.CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.POST_CD,'X') <> IFNULL(HPA.POST_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR1 , 'X') <> IFNULL(HPA.ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR2,'X') <> IFNULL(HPA.ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR3,'X') <> IFNULL(HPA.ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR4,'X') <> IFNULL(HPA.ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR5,'X') <> IFNULL(HPA.ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR6,'X') <> IFNULL(HPA.ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR7,'X') <> IFNULL(HPA.ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR8,'X') <>  IFNULL(HPA.ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR9,'X') <> IFNULL(HPA.ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR10,'X') <> IFNULL(HPA.ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR1, 'X') <> IFNULL(HPA.DTL_ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR2,'X') <> IFNULL(HPA.DTL_ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR3,'X') <> IFNULL(HPA.DTL_ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR4,'X') <> IFNULL(HPA.DTL_ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR5,'X') <> IFNULL(HPA.DTL_ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR6 ,'X') <> IFNULL(HPA.DTL_ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR7,'X') <> IFNULL(HPA.DTL_ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR8,'X') <> IFNULL(HPA.DTL_ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR9,'X') <> IFNULL(HPA.DTL_ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR10,'X') <> IFNULL(HPA.DTL_ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR11,'X') <> IFNULL(HPA.DTL_ADDR11,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR12,'X') <> IFNULL(HPA.DTL_ADDR12,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR13,'X') <> IFNULL(HPA.DTL_ADDR13,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR14,'X') <> IFNULL(HPA.DTL_ADDR14,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR15,'X') <> IFNULL(HPA.DTL_ADDR15,'X') THEN 'U'
                    WHEN IFNULL(RCV.PROVINCE,'X') <> IFNULL(HPA.PROVINCE,'X') THEN 'U'
                    WHEN IFNULL(RCV.CITY,'X') <>  IFNULL(HPA.CITY,'X') THEN 'U'
                    WHEN IFNULL(RCV.STATE,'X') <> IFNULL(HPA.STATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.START_DATE,'X') <> IFNULL(HPA.START_DATE,'X') THEN 'U'
                    ELSE 'N'
               END AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.SEQ_ID ASC) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON RCV.EMP_ID = HPM.EMP_ID
        LEFT OUTER JOIN HR_PSN_ADDRESS HPA
                        ON  RCV.EMP_ID = HPA.EMP_ID
                        AND RCV.ADDR_TYPE = HPA.ADDR_TYPE
       ) T
WHERE  ROW_NUM BETWEEN ((4 * 10000) - (10000 - 1)) AND 4 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:03:10.638112Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986136  server_id: 1710140860
# Query_time: 5.562034  Lock_time: 0.000177 Rows_sent: 0  Rows_examined: 214222
SET timestamp=1659520985;
UPDATE HR_IF_PSN_QUALIFICATION_C_PRE_RCV PRE
JOIN   HR_IF_PSN_QUALIFICATION_RCV       RCV
       ON  RCV.BATCH_ID = 1366
       AND PRE.SEQ_ID = RCV.CHILD_SEQ_ID
SET    PRE.TRANSFER_DATE = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
      ,PRE.TRANSFER_FLAG = 'Y'
WHERE  PRE.TRANSFER_FLAG = 'N'
/* [BizActor].[DAC_HR_PSN_IF_QualificationInfo_Adhoc].[DAS_HR_UpdateQualificationCPreTransferFlag] */;
# Time: 2022-08-03T10:03:21.475328Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 9.913691  Lock_time: 0.000667 Rows_sent: 10000  Rows_examined: 26314240
SET timestamp=1659520991;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_USER_ID
      ,T.SF_PERSON_ID
      ,T.SEQ_ID
      ,T.EMP_NO
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      -- 二쇱냼 ?뺣낫 硫붿씤
      ,T.ADDR_TYPE
      ,T.CNTRY_CD
      ,T.POST_CD
      ,T.ADDR1
      ,T.ADDR2
      ,T.ADDR3
      ,T.ADDR4
      ,T.ADDR5
      ,T.ADDR6
      ,T.ADDR7
      ,T.ADDR8
      ,T.ADDR9
      ,T.ADDR10
      ,T.DTL_ADDR1
      ,T.DTL_ADDR2
      ,T.DTL_ADDR3
      ,T.DTL_ADDR4
      ,T.DTL_ADDR5
      ,T.DTL_ADDR6
      ,T.DTL_ADDR7
      ,T.DTL_ADDR8
      ,T.DTL_ADDR9
      ,T.DTL_ADDR10
      ,T.DTL_ADDR11
      ,T.DTL_ADDR12
      ,T.DTL_ADDR13
      ,T.DTL_ADDR14
      ,T.DTL_ADDR15
      ,T.PROVINCE
      ,T.CITY
      ,T.STATE
      ,T.START_DATE
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HIPAP.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,HIPAP.SEQ_ID
                           ,HIPAP.SF_KEY_ID1
                           ,HIPAP.SF_LST_UPDT_DT
                           -- 遺?묎?議깆젙蹂?硫붿씤
                           ,HIPAP.ADDR_TYPE
                        -- ,HIPAP.CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = HIPAP.CNTRY_CD) AS CNTRY_CD                           
                           ,HIPAP.POST_CD
                           ,IFNULL(HIPAP.ADDR1_CD,  HIPAP.ADDR1)  AS ADDR1
                           ,IFNULL(HIPAP.ADDR2_CD,  HIPAP.ADDR2)  AS ADDR2
                           ,IFNULL(HIPAP.ADDR3_CD,  HIPAP.ADDR3)  AS ADDR3
                           ,IFNULL(HIPAP.ADDR4_CD,  HIPAP.ADDR4)  AS ADDR4
                           ,IFNULL(HIPAP.ADDR5_CD,  HIPAP.ADDR5)  AS ADDR5
                           ,IFNULL(HIPAP.ADDR6_CD,  HIPAP.ADDR6)  AS ADDR6
                           ,IFNULL(HIPAP.ADDR7_CD,  HIPAP.ADDR7)  AS ADDR7
                           ,IFNULL(HIPAP.ADDR8_CD,  HIPAP.ADDR8)  AS ADDR8
                           ,IFNULL(HIPAP.ADDR9_CD,  HIPAP.ADDR9)  AS ADDR9
                           ,IFNULL(HIPAP.ADDR10_CD, HIPAP.ADDR10) AS ADDR10
                           ,IFNULL(HIPAP.ADDR11_CD, HIPAP.ADDR11) AS DTL_ADDR1
                           ,IFNULL(HIPAP.ADDR12_CD, HIPAP.ADDR12) AS DTL_ADDR2
                           ,IFNULL(HIPAP.ADDR13_CD, HIPAP.ADDR13) AS DTL_ADDR3
                           ,IFNULL(HIPAP.ADDR14_CD, HIPAP.ADDR14) AS DTL_ADDR4
                           ,IFNULL(HIPAP.ADDR15_CD, HIPAP.ADDR15) AS DTL_ADDR5
                           ,IFNULL(HIPAP.ADDR16_CD, HIPAP.ADDR16) AS DTL_ADDR6
                           ,IFNULL(HIPAP.ADDR17_CD, HIPAP.ADDR17) AS DTL_ADDR7
                           ,IFNULL(HIPAP.ADDR18_CD, HIPAP.ADDR18) AS DTL_ADDR8
                           ,IFNULL(HIPAP.ADDR19_CD, HIPAP.ADDR19) AS DTL_ADDR9
                           ,IFNULL(HIPAP.ADDR20_CD, HIPAP.ADDR20) AS DTL_ADDR10
                           ,HIPAP.CUSTOM_STRING1   AS DTL_ADDR11
                           ,HIPAP.CUSTOM_STRING2 AS DTL_ADDR12
                           ,HIPAP.CUSTOM_STRING3 AS DTL_ADDR13
                           ,HIPAP.CUSTOM_STRING4 AS DTL_ADDR14
                           ,HIPAP.CUSTOM_STRING5 AS DTL_ADDR15
                           ,IFNULL(HIPAP.PROVINCE_CD, HIPAP.PROVINCE) AS PROVINCE
                           ,IFNULL(HIPAP.CITY_CD, HIPAP.CITY) AS CITY
                           ,HIPAP.STATE
                           ,HIPAP.START_DATE
                     FROM   HR_IF_PSN_ADDRESS_PRE_RCV  HIPAP
                     JOIN   (
                             SELECT A.SF_PERSON_ID
                                   ,MAX(A.START_DATE) AS START_DATE
                                   ,A.ADDR_TYPE 
                             FROM   HR_IF_PSN_ADDRESS_PRE_RCV  A
                             JOIN   HR_PSN_MST HPM
                                    ON A.SF_PERSON_ID = HPM.SF_PERSON_ID
                             WHERE  A.TRANSFER_FLAG = 'N'
                             AND    HPM.REP_COMP_CD IS NOT NULL
                             AND    A.START_DATE <= SYSDATE()
                             GROUP BY A.SF_PERSON_ID,A.ADDR_TYPE
                             ) M
                            ON  M.SF_PERSON_ID = HIPAP.SF_PERSON_ID
                            AND M.ADDR_TYPE = HIPAP.ADDR_TYPE
                            AND M.START_DATE = HIPAP.START_DATE
                     JOIN   HR_PSN_MST HPM
                            ON HIPAP.SF_PERSON_ID = HPM.SF_PERSON_ID
                     WHERE  HIPAP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_USER_ID
              ,RCV.SF_PERSON_ID
              ,RCV.SEQ_ID
              ,RCV.EMP_NO
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              -- 二쇱냼 ?뺣낫 硫붿씤
              ,RCV.ADDR_TYPE
              ,RCV.CNTRY_CD
              ,RCV.POST_CD
              ,RCV.ADDR1
              ,RCV.ADDR2
              ,RCV.ADDR3
              ,RCV.ADDR4
              ,RCV.ADDR5
              ,RCV.ADDR6
              ,RCV.ADDR7
              ,RCV.ADDR8
              ,RCV.ADDR9
              ,RCV.ADDR10
              ,RCV.DTL_ADDR1
              ,RCV.DTL_ADDR2
              ,RCV.DTL_ADDR3
              ,RCV.DTL_ADDR4
              ,RCV.DTL_ADDR5
              ,RCV.DTL_ADDR6
              ,RCV.DTL_ADDR7
              ,RCV.DTL_ADDR8
              ,RCV.DTL_ADDR9
              ,RCV.DTL_ADDR10
              ,RCV.DTL_ADDR11
              ,RCV.DTL_ADDR12
              ,RCV.DTL_ADDR13
              ,RCV.DTL_ADDR14
              ,RCV.DTL_ADDR15
              ,RCV.PROVINCE
              ,RCV.CITY
              ,RCV.STATE
              ,RCV.START_DATE
              ,CASE WHEN HPA.EMP_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.CNTRY_CD,'X') <> IFNULL(HPA.CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.POST_CD,'X') <> IFNULL(HPA.POST_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR1 , 'X') <> IFNULL(HPA.ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR2,'X') <> IFNULL(HPA.ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR3,'X') <> IFNULL(HPA.ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR4,'X') <> IFNULL(HPA.ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR5,'X') <> IFNULL(HPA.ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR6,'X') <> IFNULL(HPA.ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR7,'X') <> IFNULL(HPA.ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR8,'X') <>  IFNULL(HPA.ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR9,'X') <> IFNULL(HPA.ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR10,'X') <> IFNULL(HPA.ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR1, 'X') <> IFNULL(HPA.DTL_ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR2,'X') <> IFNULL(HPA.DTL_ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR3,'X') <> IFNULL(HPA.DTL_ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR4,'X') <> IFNULL(HPA.DTL_ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR5,'X') <> IFNULL(HPA.DTL_ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR6 ,'X') <> IFNULL(HPA.DTL_ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR7,'X') <> IFNULL(HPA.DTL_ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR8,'X') <> IFNULL(HPA.DTL_ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR9,'X') <> IFNULL(HPA.DTL_ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR10,'X') <> IFNULL(HPA.DTL_ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR11,'X') <> IFNULL(HPA.DTL_ADDR11,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR12,'X') <> IFNULL(HPA.DTL_ADDR12,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR13,'X') <> IFNULL(HPA.DTL_ADDR13,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR14,'X') <> IFNULL(HPA.DTL_ADDR14,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR15,'X') <> IFNULL(HPA.DTL_ADDR15,'X') THEN 'U'
                    WHEN IFNULL(RCV.PROVINCE,'X') <> IFNULL(HPA.PROVINCE,'X') THEN 'U'
                    WHEN IFNULL(RCV.CITY,'X') <>  IFNULL(HPA.CITY,'X') THEN 'U'
                    WHEN IFNULL(RCV.STATE,'X') <> IFNULL(HPA.STATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.START_DATE,'X') <> IFNULL(HPA.START_DATE,'X') THEN 'U'
                    ELSE 'N'
               END AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.SEQ_ID ASC) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON RCV.EMP_ID = HPM.EMP_ID
        LEFT OUTER JOIN HR_PSN_ADDRESS HPA
                        ON  RCV.EMP_ID = HPA.EMP_ID
                        AND RCV.ADDR_TYPE = HPA.ADDR_TYPE
       ) T
WHERE  ROW_NUM BETWEEN ((5 * 10000) - (10000 - 1)) AND 5 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:03:35.338370Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 9.799505  Lock_time: 0.000740 Rows_sent: 10000  Rows_examined: 26314240
SET timestamp=1659521005;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_USER_ID
      ,T.SF_PERSON_ID
      ,T.SEQ_ID
      ,T.EMP_NO
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      -- 二쇱냼 ?뺣낫 硫붿씤
      ,T.ADDR_TYPE
      ,T.CNTRY_CD
      ,T.POST_CD
      ,T.ADDR1
      ,T.ADDR2
      ,T.ADDR3
      ,T.ADDR4
      ,T.ADDR5
      ,T.ADDR6
      ,T.ADDR7
      ,T.ADDR8
      ,T.ADDR9
      ,T.ADDR10
      ,T.DTL_ADDR1
      ,T.DTL_ADDR2
      ,T.DTL_ADDR3
      ,T.DTL_ADDR4
      ,T.DTL_ADDR5
      ,T.DTL_ADDR6
      ,T.DTL_ADDR7
      ,T.DTL_ADDR8
      ,T.DTL_ADDR9
      ,T.DTL_ADDR10
      ,T.DTL_ADDR11
      ,T.DTL_ADDR12
      ,T.DTL_ADDR13
      ,T.DTL_ADDR14
      ,T.DTL_ADDR15
      ,T.PROVINCE
      ,T.CITY
      ,T.STATE
      ,T.START_DATE
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HIPAP.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,HIPAP.SEQ_ID
                           ,HIPAP.SF_KEY_ID1
                           ,HIPAP.SF_LST_UPDT_DT
                           -- 遺?묎?議깆젙蹂?硫붿씤
                           ,HIPAP.ADDR_TYPE
                        -- ,HIPAP.CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = HIPAP.CNTRY_CD) AS CNTRY_CD                           
                           ,HIPAP.POST_CD
                           ,IFNULL(HIPAP.ADDR1_CD,  HIPAP.ADDR1)  AS ADDR1
                           ,IFNULL(HIPAP.ADDR2_CD,  HIPAP.ADDR2)  AS ADDR2
                           ,IFNULL(HIPAP.ADDR3_CD,  HIPAP.ADDR3)  AS ADDR3
                           ,IFNULL(HIPAP.ADDR4_CD,  HIPAP.ADDR4)  AS ADDR4
                           ,IFNULL(HIPAP.ADDR5_CD,  HIPAP.ADDR5)  AS ADDR5
                           ,IFNULL(HIPAP.ADDR6_CD,  HIPAP.ADDR6)  AS ADDR6
                           ,IFNULL(HIPAP.ADDR7_CD,  HIPAP.ADDR7)  AS ADDR7
                           ,IFNULL(HIPAP.ADDR8_CD,  HIPAP.ADDR8)  AS ADDR8
                           ,IFNULL(HIPAP.ADDR9_CD,  HIPAP.ADDR9)  AS ADDR9
                           ,IFNULL(HIPAP.ADDR10_CD, HIPAP.ADDR10) AS ADDR10
                           ,IFNULL(HIPAP.ADDR11_CD, HIPAP.ADDR11) AS DTL_ADDR1
                           ,IFNULL(HIPAP.ADDR12_CD, HIPAP.ADDR12) AS DTL_ADDR2
                           ,IFNULL(HIPAP.ADDR13_CD, HIPAP.ADDR13) AS DTL_ADDR3
                           ,IFNULL(HIPAP.ADDR14_CD, HIPAP.ADDR14) AS DTL_ADDR4
                           ,IFNULL(HIPAP.ADDR15_CD, HIPAP.ADDR15) AS DTL_ADDR5
                           ,IFNULL(HIPAP.ADDR16_CD, HIPAP.ADDR16) AS DTL_ADDR6
                           ,IFNULL(HIPAP.ADDR17_CD, HIPAP.ADDR17) AS DTL_ADDR7
                           ,IFNULL(HIPAP.ADDR18_CD, HIPAP.ADDR18) AS DTL_ADDR8
                           ,IFNULL(HIPAP.ADDR19_CD, HIPAP.ADDR19) AS DTL_ADDR9
                           ,IFNULL(HIPAP.ADDR20_CD, HIPAP.ADDR20) AS DTL_ADDR10
                           ,HIPAP.CUSTOM_STRING1   AS DTL_ADDR11
                           ,HIPAP.CUSTOM_STRING2 AS DTL_ADDR12
                           ,HIPAP.CUSTOM_STRING3 AS DTL_ADDR13
                           ,HIPAP.CUSTOM_STRING4 AS DTL_ADDR14
                           ,HIPAP.CUSTOM_STRING5 AS DTL_ADDR15
                           ,IFNULL(HIPAP.PROVINCE_CD, HIPAP.PROVINCE) AS PROVINCE
                           ,IFNULL(HIPAP.CITY_CD, HIPAP.CITY) AS CITY
                           ,HIPAP.STATE
                           ,HIPAP.START_DATE
                     FROM   HR_IF_PSN_ADDRESS_PRE_RCV  HIPAP
                     JOIN   (
                             SELECT A.SF_PERSON_ID
                                   ,MAX(A.START_DATE) AS START_DATE
                                   ,A.ADDR_TYPE 
                             FROM   HR_IF_PSN_ADDRESS_PRE_RCV  A
                             JOIN   HR_PSN_MST HPM
                                    ON A.SF_PERSON_ID = HPM.SF_PERSON_ID
                             WHERE  A.TRANSFER_FLAG = 'N'
                             AND    HPM.REP_COMP_CD IS NOT NULL
                             AND    A.START_DATE <= SYSDATE()
                             GROUP BY A.SF_PERSON_ID,A.ADDR_TYPE
                             ) M
                            ON  M.SF_PERSON_ID = HIPAP.SF_PERSON_ID
                            AND M.ADDR_TYPE = HIPAP.ADDR_TYPE
                            AND M.START_DATE = HIPAP.START_DATE
                     JOIN   HR_PSN_MST HPM
                            ON HIPAP.SF_PERSON_ID = HPM.SF_PERSON_ID
                     WHERE  HIPAP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_USER_ID
              ,RCV.SF_PERSON_ID
              ,RCV.SEQ_ID
              ,RCV.EMP_NO
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              -- 二쇱냼 ?뺣낫 硫붿씤
              ,RCV.ADDR_TYPE
              ,RCV.CNTRY_CD
              ,RCV.POST_CD
              ,RCV.ADDR1
              ,RCV.ADDR2
              ,RCV.ADDR3
              ,RCV.ADDR4
              ,RCV.ADDR5
              ,RCV.ADDR6
              ,RCV.ADDR7
              ,RCV.ADDR8
              ,RCV.ADDR9
              ,RCV.ADDR10
              ,RCV.DTL_ADDR1
              ,RCV.DTL_ADDR2
              ,RCV.DTL_ADDR3
              ,RCV.DTL_ADDR4
              ,RCV.DTL_ADDR5
              ,RCV.DTL_ADDR6
              ,RCV.DTL_ADDR7
              ,RCV.DTL_ADDR8
              ,RCV.DTL_ADDR9
              ,RCV.DTL_ADDR10
              ,RCV.DTL_ADDR11
              ,RCV.DTL_ADDR12
              ,RCV.DTL_ADDR13
              ,RCV.DTL_ADDR14
              ,RCV.DTL_ADDR15
              ,RCV.PROVINCE
              ,RCV.CITY
              ,RCV.STATE
              ,RCV.START_DATE
              ,CASE WHEN HPA.EMP_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.CNTRY_CD,'X') <> IFNULL(HPA.CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.POST_CD,'X') <> IFNULL(HPA.POST_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR1 , 'X') <> IFNULL(HPA.ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR2,'X') <> IFNULL(HPA.ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR3,'X') <> IFNULL(HPA.ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR4,'X') <> IFNULL(HPA.ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR5,'X') <> IFNULL(HPA.ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR6,'X') <> IFNULL(HPA.ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR7,'X') <> IFNULL(HPA.ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR8,'X') <>  IFNULL(HPA.ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR9,'X') <> IFNULL(HPA.ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR10,'X') <> IFNULL(HPA.ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR1, 'X') <> IFNULL(HPA.DTL_ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR2,'X') <> IFNULL(HPA.DTL_ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR3,'X') <> IFNULL(HPA.DTL_ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR4,'X') <> IFNULL(HPA.DTL_ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR5,'X') <> IFNULL(HPA.DTL_ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR6 ,'X') <> IFNULL(HPA.DTL_ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR7,'X') <> IFNULL(HPA.DTL_ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR8,'X') <> IFNULL(HPA.DTL_ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR9,'X') <> IFNULL(HPA.DTL_ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR10,'X') <> IFNULL(HPA.DTL_ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR11,'X') <> IFNULL(HPA.DTL_ADDR11,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR12,'X') <> IFNULL(HPA.DTL_ADDR12,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR13,'X') <> IFNULL(HPA.DTL_ADDR13,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR14,'X') <> IFNULL(HPA.DTL_ADDR14,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR15,'X') <> IFNULL(HPA.DTL_ADDR15,'X') THEN 'U'
                    WHEN IFNULL(RCV.PROVINCE,'X') <> IFNULL(HPA.PROVINCE,'X') THEN 'U'
                    WHEN IFNULL(RCV.CITY,'X') <>  IFNULL(HPA.CITY,'X') THEN 'U'
                    WHEN IFNULL(RCV.STATE,'X') <> IFNULL(HPA.STATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.START_DATE,'X') <> IFNULL(HPA.START_DATE,'X') THEN 'U'
                    ELSE 'N'
               END AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.SEQ_ID ASC) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON RCV.EMP_ID = HPM.EMP_ID
        LEFT OUTER JOIN HR_PSN_ADDRESS HPA
                        ON  RCV.EMP_ID = HPA.EMP_ID
                        AND RCV.ADDR_TYPE = HPA.ADDR_TYPE
       ) T
WHERE  ROW_NUM BETWEEN ((6 * 10000) - (10000 - 1)) AND 6 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:03:50.138132Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 10.241561  Lock_time: 0.000843 Rows_sent: 10000  Rows_examined: 26314240
SET timestamp=1659521019;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_USER_ID
      ,T.SF_PERSON_ID
      ,T.SEQ_ID
      ,T.EMP_NO
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      -- 二쇱냼 ?뺣낫 硫붿씤
      ,T.ADDR_TYPE
      ,T.CNTRY_CD
      ,T.POST_CD
      ,T.ADDR1
      ,T.ADDR2
      ,T.ADDR3
      ,T.ADDR4
      ,T.ADDR5
      ,T.ADDR6
      ,T.ADDR7
      ,T.ADDR8
      ,T.ADDR9
      ,T.ADDR10
      ,T.DTL_ADDR1
      ,T.DTL_ADDR2
      ,T.DTL_ADDR3
      ,T.DTL_ADDR4
      ,T.DTL_ADDR5
      ,T.DTL_ADDR6
      ,T.DTL_ADDR7
      ,T.DTL_ADDR8
      ,T.DTL_ADDR9
      ,T.DTL_ADDR10
      ,T.DTL_ADDR11
      ,T.DTL_ADDR12
      ,T.DTL_ADDR13
      ,T.DTL_ADDR14
      ,T.DTL_ADDR15
      ,T.PROVINCE
      ,T.CITY
      ,T.STATE
      ,T.START_DATE
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HIPAP.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,HIPAP.SEQ_ID
                           ,HIPAP.SF_KEY_ID1
                           ,HIPAP.SF_LST_UPDT_DT
                           -- 遺?묎?議깆젙蹂?硫붿씤
                           ,HIPAP.ADDR_TYPE
                        -- ,HIPAP.CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = HIPAP.CNTRY_CD) AS CNTRY_CD                           
                           ,HIPAP.POST_CD
                           ,IFNULL(HIPAP.ADDR1_CD,  HIPAP.ADDR1)  AS ADDR1
                           ,IFNULL(HIPAP.ADDR2_CD,  HIPAP.ADDR2)  AS ADDR2
                           ,IFNULL(HIPAP.ADDR3_CD,  HIPAP.ADDR3)  AS ADDR3
                           ,IFNULL(HIPAP.ADDR4_CD,  HIPAP.ADDR4)  AS ADDR4
                           ,IFNULL(HIPAP.ADDR5_CD,  HIPAP.ADDR5)  AS ADDR5
                           ,IFNULL(HIPAP.ADDR6_CD,  HIPAP.ADDR6)  AS ADDR6
                           ,IFNULL(HIPAP.ADDR7_CD,  HIPAP.ADDR7)  AS ADDR7
                           ,IFNULL(HIPAP.ADDR8_CD,  HIPAP.ADDR8)  AS ADDR8
                           ,IFNULL(HIPAP.ADDR9_CD,  HIPAP.ADDR9)  AS ADDR9
                           ,IFNULL(HIPAP.ADDR10_CD, HIPAP.ADDR10) AS ADDR10
                           ,IFNULL(HIPAP.ADDR11_CD, HIPAP.ADDR11) AS DTL_ADDR1
                           ,IFNULL(HIPAP.ADDR12_CD, HIPAP.ADDR12) AS DTL_ADDR2
                           ,IFNULL(HIPAP.ADDR13_CD, HIPAP.ADDR13) AS DTL_ADDR3
                           ,IFNULL(HIPAP.ADDR14_CD, HIPAP.ADDR14) AS DTL_ADDR4
                           ,IFNULL(HIPAP.ADDR15_CD, HIPAP.ADDR15) AS DTL_ADDR5
                           ,IFNULL(HIPAP.ADDR16_CD, HIPAP.ADDR16) AS DTL_ADDR6
                           ,IFNULL(HIPAP.ADDR17_CD, HIPAP.ADDR17) AS DTL_ADDR7
                           ,IFNULL(HIPAP.ADDR18_CD, HIPAP.ADDR18) AS DTL_ADDR8
                           ,IFNULL(HIPAP.ADDR19_CD, HIPAP.ADDR19) AS DTL_ADDR9
                           ,IFNULL(HIPAP.ADDR20_CD, HIPAP.ADDR20) AS DTL_ADDR10
                           ,HIPAP.CUSTOM_STRING1   AS DTL_ADDR11
                           ,HIPAP.CUSTOM_STRING2 AS DTL_ADDR12
                           ,HIPAP.CUSTOM_STRING3 AS DTL_ADDR13
                           ,HIPAP.CUSTOM_STRING4 AS DTL_ADDR14
                           ,HIPAP.CUSTOM_STRING5 AS DTL_ADDR15
                           ,IFNULL(HIPAP.PROVINCE_CD, HIPAP.PROVINCE) AS PROVINCE
                           ,IFNULL(HIPAP.CITY_CD, HIPAP.CITY) AS CITY
                           ,HIPAP.STATE
                           ,HIPAP.START_DATE
                     FROM   HR_IF_PSN_ADDRESS_PRE_RCV  HIPAP
                     JOIN   (
                             SELECT A.SF_PERSON_ID
                                   ,MAX(A.START_DATE) AS START_DATE
                                   ,A.ADDR_TYPE 
                             FROM   HR_IF_PSN_ADDRESS_PRE_RCV  A
                             JOIN   HR_PSN_MST HPM
                                    ON A.SF_PERSON_ID = HPM.SF_PERSON_ID
                             WHERE  A.TRANSFER_FLAG = 'N'
                             AND    HPM.REP_COMP_CD IS NOT NULL
                             AND    A.START_DATE <= SYSDATE()
                             GROUP BY A.SF_PERSON_ID,A.ADDR_TYPE
                             ) M
                            ON  M.SF_PERSON_ID = HIPAP.SF_PERSON_ID
                            AND M.ADDR_TYPE = HIPAP.ADDR_TYPE
                            AND M.START_DATE = HIPAP.START_DATE
                     JOIN   HR_PSN_MST HPM
                            ON HIPAP.SF_PERSON_ID = HPM.SF_PERSON_ID
                     WHERE  HIPAP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_USER_ID
              ,RCV.SF_PERSON_ID
              ,RCV.SEQ_ID
              ,RCV.EMP_NO
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              -- 二쇱냼 ?뺣낫 硫붿씤
              ,RCV.ADDR_TYPE
              ,RCV.CNTRY_CD
              ,RCV.POST_CD
              ,RCV.ADDR1
              ,RCV.ADDR2
              ,RCV.ADDR3
              ,RCV.ADDR4
              ,RCV.ADDR5
              ,RCV.ADDR6
              ,RCV.ADDR7
              ,RCV.ADDR8
              ,RCV.ADDR9
              ,RCV.ADDR10
              ,RCV.DTL_ADDR1
              ,RCV.DTL_ADDR2
              ,RCV.DTL_ADDR3
              ,RCV.DTL_ADDR4
              ,RCV.DTL_ADDR5
              ,RCV.DTL_ADDR6
              ,RCV.DTL_ADDR7
              ,RCV.DTL_ADDR8
              ,RCV.DTL_ADDR9
              ,RCV.DTL_ADDR10
              ,RCV.DTL_ADDR11
              ,RCV.DTL_ADDR12
              ,RCV.DTL_ADDR13
              ,RCV.DTL_ADDR14
              ,RCV.DTL_ADDR15
              ,RCV.PROVINCE
              ,RCV.CITY
              ,RCV.STATE
              ,RCV.START_DATE
              ,CASE WHEN HPA.EMP_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.CNTRY_CD,'X') <> IFNULL(HPA.CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.POST_CD,'X') <> IFNULL(HPA.POST_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR1 , 'X') <> IFNULL(HPA.ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR2,'X') <> IFNULL(HPA.ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR3,'X') <> IFNULL(HPA.ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR4,'X') <> IFNULL(HPA.ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR5,'X') <> IFNULL(HPA.ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR6,'X') <> IFNULL(HPA.ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR7,'X') <> IFNULL(HPA.ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR8,'X') <>  IFNULL(HPA.ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR9,'X') <> IFNULL(HPA.ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR10,'X') <> IFNULL(HPA.ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR1, 'X') <> IFNULL(HPA.DTL_ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR2,'X') <> IFNULL(HPA.DTL_ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR3,'X') <> IFNULL(HPA.DTL_ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR4,'X') <> IFNULL(HPA.DTL_ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR5,'X') <> IFNULL(HPA.DTL_ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR6 ,'X') <> IFNULL(HPA.DTL_ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR7,'X') <> IFNULL(HPA.DTL_ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR8,'X') <> IFNULL(HPA.DTL_ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR9,'X') <> IFNULL(HPA.DTL_ADDR9,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR10,'X') <> IFNULL(HPA.DTL_ADDR10,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR11,'X') <> IFNULL(HPA.DTL_ADDR11,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR12,'X') <> IFNULL(HPA.DTL_ADDR12,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR13,'X') <> IFNULL(HPA.DTL_ADDR13,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR14,'X') <> IFNULL(HPA.DTL_ADDR14,'X') THEN 'U'
                    WHEN IFNULL(RCV.DTL_ADDR15,'X') <> IFNULL(HPA.DTL_ADDR15,'X') THEN 'U'
                    WHEN IFNULL(RCV.PROVINCE,'X') <> IFNULL(HPA.PROVINCE,'X') THEN 'U'
                    WHEN IFNULL(RCV.CITY,'X') <>  IFNULL(HPA.CITY,'X') THEN 'U'
                    WHEN IFNULL(RCV.STATE,'X') <> IFNULL(HPA.STATE,'X') THEN 'U'
                    WHEN IFNULL(RCV.START_DATE,'X') <> IFNULL(HPA.START_DATE,'X') THEN 'U'
                    ELSE 'N'
               END AS CUD_KEY
              ,ROW_NUMBER() OVER (ORDER BY RCV.SEQ_ID ASC) AS ROW_NUM
        FROM   RCV
        JOIN   HR_PSN_MST HPM
               ON RCV.EMP_ID = HPM.EMP_ID
        LEFT OUTER JOIN HR_PSN_ADDRESS HPA
                        ON  RCV.EMP_ID = HPA.EMP_ID
                        AND RCV.ADDR_TYPE = HPA.ADDR_TYPE
       ) T
WHERE  ROW_NUM BETWEEN ((7 * 10000) - (10000 - 1)) AND 7 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:04:04.436527Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 9.739280  Lock_time: 0.000804 Rows_sent: 10000  Rows_examined: 26314240
SET timestamp=1659521034;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
      ,T.EMP_ID
      ,T.SF_USER_ID
      ,T.SF_PERSON_ID
      ,T.SEQ_ID
      ,T.EMP_NO
      ,T.SF_KEY_ID1
      ,T.SF_LST_UPDT_DT
      -- 二쇱냼 ?뺣낫 硫붿씤
      ,T.ADDR_TYPE
      ,T.CNTRY_CD
      ,T.POST_CD
      ,T.ADDR1
      ,T.ADDR2
      ,T.ADDR3
      ,T.ADDR4
      ,T.ADDR5
      ,T.ADDR6
      ,T.ADDR7
      ,T.ADDR8
      ,T.ADDR9
      ,T.ADDR10
      ,T.DTL_ADDR1
      ,T.DTL_ADDR2
      ,T.DTL_ADDR3
      ,T.DTL_ADDR4
      ,T.DTL_ADDR5
      ,T.DTL_ADDR6
      ,T.DTL_ADDR7
      ,T.DTL_ADDR8
      ,T.DTL_ADDR9
      ,T.DTL_ADDR10
      ,T.DTL_ADDR11
      ,T.DTL_ADDR12
      ,T.DTL_ADDR13
      ,T.DTL_ADDR14
      ,T.DTL_ADDR15
      ,T.PROVINCE
      ,T.CITY
      ,T.STATE
      ,T.START_DATE
      ,T.CUD_KEY
FROM   (WITH RCV AS (SELECT HPM.REP_COMP_CD
                           ,HPM.COMP_CD
                           ,HPM.EMP_ID
                           ,HIPAP.SF_PERSON_ID
                           ,HPM.EMP_NO
                           ,HPM.SF_USER_ID
                           ,HIPAP.SEQ_ID
                           ,HIPAP.SF_KEY_ID1
                           ,HIPAP.SF_LST_UPDT_DT
                           -- 遺?묎?議깆젙蹂?硫붿씤
                           ,HIPAP.ADDR_TYPE
                        -- ,HIPAP.CNTRY_CD
                           ,(SELECT C.CNTRY_CD FROM CM_COUNTRY C WHERE C.ISO_CD = HIPAP.CNTRY_CD) AS CNTRY_CD                           
                           ,HIPAP.POST_CD
                           ,IFNULL(HIPAP.ADDR1_CD,  HIPAP.ADDR1)  AS ADDR1
                           ,IFNULL(HIPAP.ADDR2_CD,  HIPAP.ADDR2)  AS ADDR2
                           ,IFNULL(HIPAP.ADDR3_CD,  HIPAP.ADDR3)  AS ADDR3
                           ,IFNULL(HIPAP.ADDR4_CD,  HIPAP.ADDR4)  AS ADDR4
                           ,IFNULL(HIPAP.ADDR5_CD,  HIPAP.ADDR5)  AS ADDR5
                           ,IFNULL(HIPAP.ADDR6_CD,  HIPAP.ADDR6)  AS ADDR6
                           ,IFNULL(HIPAP.ADDR7_CD,  HIPAP.ADDR7)  AS ADDR7
                           ,IFNULL(HIPAP.ADDR8_CD,  HIPAP.ADDR8)  AS ADDR8
                           ,IFNULL(HIPAP.ADDR9_CD,  HIPAP.ADDR9)  AS ADDR9
                           ,IFNULL(HIPAP.ADDR10_CD, HIPAP.ADDR10) AS ADDR10
                           ,IFNULL(HIPAP.ADDR11_CD, HIPAP.ADDR11) AS DTL_ADDR1
                           ,IFNULL(HIPAP.ADDR12_CD, HIPAP.ADDR12) AS DTL_ADDR2
                           ,IFNULL(HIPAP.ADDR13_CD, HIPAP.ADDR13) AS DTL_ADDR3
                           ,IFNULL(HIPAP.ADDR14_CD, HIPAP.ADDR14) AS DTL_ADDR4
                           ,IFNULL(HIPAP.ADDR15_CD, HIPAP.ADDR15) AS DTL_ADDR5
                           ,IFNULL(HIPAP.ADDR16_CD, HIPAP.ADDR16) AS DTL_ADDR6
                           ,IFNULL(HIPAP.ADDR17_CD, HIPAP.ADDR17) AS DTL_ADDR7
                           ,IFNULL(HIPAP.ADDR18_CD, HIPAP.ADDR18) AS DTL_ADDR8
                           ,IFNULL(HIPAP.ADDR19_CD, HIPAP.ADDR19) AS DTL_ADDR9
                           ,IFNULL(HIPAP.ADDR20_CD, HIPAP.ADDR20) AS DTL_ADDR10
                           ,HIPAP.CUSTOM_STRING1   AS DTL_ADDR11
                           ,HIPAP.CUSTOM_STRING2 AS DTL_ADDR12
                           ,HIPAP.CUSTOM_STRING3 AS DTL_ADDR13
                           ,HIPAP.CUSTOM_STRING4 AS DTL_ADDR14
                           ,HIPAP.CUSTOM_STRING5 AS DTL_ADDR15
                           ,IFNULL(HIPAP.PROVINCE_CD, HIPAP.PROVINCE) AS PROVINCE
                           ,IFNULL(HIPAP.CITY_CD, HIPAP.CITY) AS CITY
                           ,HIPAP.STATE
                           ,HIPAP.START_DATE
                     FROM   HR_IF_PSN_ADDRESS_PRE_RCV  HIPAP
                     JOIN   (
                             SELECT A.SF_PERSON_ID
                                   ,MAX(A.START_DATE) AS START_DATE
                                   ,A.ADDR_TYPE 
                             FROM   HR_IF_PSN_ADDRESS_PRE_RCV  A
                             JOIN   HR_PSN_MST HPM
                                    ON A.SF_PERSON_ID = HPM.SF_PERSON_ID
                             WHERE  A.TRANSFER_FLAG = 'N'
                             AND    HPM.REP_COMP_CD IS NOT NULL
                             AND    A.START_DATE <= SYSDATE()
                             GROUP BY A.SF_PERSON_ID,A.ADDR_TYPE
                             ) M
                            ON  M.SF_PERSON_ID = HIPAP.SF_PERSON_ID
                            AND M.ADDR_TYPE = HIPAP.ADDR_TYPE
                            AND M.START_DATE = HIPAP.START_DATE
                     JOIN   HR_PSN_MST HPM
                            ON HIPAP.SF_PERSON_ID = HPM.SF_PERSON_ID
                     WHERE  HIPAP.TRANSFER_FLAG = 'N'
                     AND    HPM.REP_COMP_CD IS NOT NULL
/*                     
WHERE */
)
        SELECT RCV.REP_COMP_CD
              ,RCV.COMP_CD
              ,RCV.EMP_ID
              ,RCV.SF_USER_ID
              ,RCV.SF_PERSON_ID
              ,RCV.SEQ_ID
              ,RCV.EMP_NO
              ,RCV.SF_KEY_ID1
              ,RCV.SF_LST_UPDT_DT
              -- 二쇱냼 ?뺣낫 硫붿씤
              ,RCV.ADDR_TYPE
              ,RCV.CNTRY_CD
              ,RCV.POST_CD
              ,RCV.ADDR1
              ,RCV.ADDR2
              ,RCV.ADDR3
              ,RCV.ADDR4
              ,RCV.ADDR5
              ,RCV.ADDR6
              ,RCV.ADDR7
              ,RCV.ADDR8
              ,RCV.ADDR9
              ,RCV.ADDR10
              ,RCV.DTL_ADDR1
              ,RCV.DTL_ADDR2
              ,RCV.DTL_ADDR3
              ,RCV.DTL_ADDR4
              ,RCV.DTL_ADDR5
              ,RCV.DTL_ADDR6
              ,RCV.DTL_ADDR7
              ,RCV.DTL_ADDR8
              ,RCV.DTL_ADDR9
              ,RCV.DTL_ADDR10
              ,RCV.DTL_ADDR11
              ,RCV.DTL_ADDR12
              ,RCV.DTL_ADDR13
              ,RCV.DTL_ADDR14
              ,RCV.DTL_ADDR15
              ,RCV.PROVINCE
              ,RCV.CITY
              ,RCV.STATE
              ,RCV.START_DATE
              ,CASE WHEN HPA.EMP_ID IS NULL THEN 'C'
                    WHEN IFNULL(RCV.CNTRY_CD,'X') <> IFNULL(HPA.CNTRY_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.POST_CD,'X') <> IFNULL(HPA.POST_CD,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR1 , 'X') <> IFNULL(HPA.ADDR1,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR2,'X') <> IFNULL(HPA.ADDR2,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR3,'X') <> IFNULL(HPA.ADDR3,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR4,'X') <> IFNULL(HPA.ADDR4,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR5,'X') <> IFNULL(HPA.ADDR5,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR6,'X') <> IFNULL(HPA.ADDR6,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR7,'X') <> IFNULL(HPA.ADDR7,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR8,'X') <>  IFNULL(HPA.ADDR8,'X') THEN 'U'
                    WHEN IFNULL(RCV.ADDR9,'X') <> IFNULL(HPA.ADDR9,'X') THEN 'U'
