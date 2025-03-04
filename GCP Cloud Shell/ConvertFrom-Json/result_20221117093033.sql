# Time: 2022-11-16T00:35:44.751263Z
# User@Host: erpapp[erpapp] @  [10.2.183.72]  thread_id: 7773410  server_id: 2886939016
# Query_time: 3.494047  Lock_time: 0.000965 Rows_sent: 6471  Rows_examined: 445914
SET timestamp=1668558941;
SELECT HPM.EMP_NO,
       HPM.EMP_NM,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'cust_JobTitle' AND CD = HAM.JOB_TITLE_CD AND COMP_CD = HPM.COMP_CD AND INV_ORG_ID = -1 AND LANG_CD = 'KO') JOB_NM,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'cust_SupervisorLevel' AND CD = HAM.POSITION_CD AND COMP_CD = HPM.COMP_CD AND INV_ORG_ID = -1 AND LANG_CD = 'KO') POSITION_NM,
       ERPAPP.db_NVL_CHAR(HOM.ORG_FULL_NM, HOM.ORG_NM) AS ORG_FULL_NM,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'cust_EmployeeClass' AND CD = HAM.EMP_TYPE AND COMP_CD = HPM.COMP_CD AND INV_ORG_ID = -1 AND LANG_CD = 'KO') EMP_TYPE_NM,
       HAS.EMP_ID,
       HAS.EFFCT_STRT_DATE,
       HAS.EFFCT_END_DATE,
--       ERPAPP.db_DATE_TO_CHAR(ERPAPP.db_TO_DATE(HAS.EFFCT_STRT_DATE, 'YYYYMMDD'), ERPAPP.db_NVL_CHAR(@DATE_FORMAT, 'YYYYMMDD')) AS STRT_DATE,
       ERPAPP.db_DATE_TO_CHAR(date_format(HAS.EFFCT_STRT_DATE, '%Y%m%d'), CASE WHEN 'YYYY/MM/DD' IS NULL THEN 'YYYYMMDD'
                                                                               WHEN 'YYYY/MM/DD' = '' THEN 'YYYYMMDD'
                                                                               ELSE 'YYYY/MM/DD' 
                                                                          END) AS STRT_DATE,
--       ERPAPP.db_DATE_TO_CHAR(ERPAPP.db_TO_DATE(HAS.EFFCT_END_DATE, 'YYYYMMDD'), ERPAPP.db_NVL_CHAR(@DATE_FORMAT, 'YYYYMMDD')) AS END_DATE,
       ERPAPP.db_DATE_TO_CHAR(date_format(HAS.EFFCT_END_DATE, '%Y%m%d'), CASE WHEN 'YYYY/MM/DD' IS NULL THEN 'YYYYMMDD'
                                                                               WHEN 'YYYY/MM/DD' = '' THEN 'YYYYMMDD'
                                                                               ELSE 'YYYY/MM/DD' 
                                                                          END) AS END_DATE,
       HAS.PRE_CHNG_DATE,
       HAS.PAY_STEP_TYPE,
       HAM.JOB_GRADE_SENIORITY,
       '' as PAY_STEP_CD,     
       HAS.PAY_STEP_ID, 
       HAS.JOB_PAY_STEP_ID,
       EVAL.EVAL_GRD,
       HAS.SALARY,
       HAS.BASE_AMT,
       HAS.PAY_VALUE1,
       HAS.STNDRD_AMT,
       HAS.PAY_VALUE2,
       HAS.PAY_VALUE3,
       HAS.MULTI_VAL,
       HAS.CHNG_RSN_CD,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'HR_SAL_CHNG_RSN' AND CD = HAS.CHNG_RSN_CD AND COMP_CD = 'N000' AND INV_ORG_ID = -1 AND LANG_CD = 'KO') CHNG_RSN_NM,
       HAS.CHNG_DESC,
       HAS.COMP_CD,
       CU.EMP_NM AS UPDT_NM,
--       ERPAPP.db_DATE_TO_CHAR(ERPAPP.db_TO_DATE(HAS.UPDT_DT, 'YYYYMMDDHH24MISS'), ERPAPP.db_CONCAT(ERPAPP.db_NVL_CHAR(@DATE_FORMAT, 'YYYYMMDD'), ' HH24:MI:SS')) AS UPDT_DT,
       ERPAPP.db_DATE_TO_CHAR(date_format(HAS.UPDT_DT, '%Y%m%d%H%i%s'), concat(CASE WHEN 'YYYY/MM/DD' IS NULL THEN 'YYYYMMDD'
                                                                                    WHEN 'YYYY/MM/DD' = '' THEN 'YYYYMMDD'
                                                                                    ELSE 'YYYY/MM/DD' 
                                                                               END, ' HH24:MI:SS')) AS UPDT_DT,
       HAS.LOCK_SEQ,
       HAS.FAC_TYPE,
       HAS.ATTR1,
       HAS.ATTR2,
       HAS.ATTR3,
       HAS.ATTR4,
       HAS.ATTR5,
       HAS.ATTR6,
       HAS.ATTR7,
       HAS.ATTR8,
       HAS.ATTR9,
       HAS.ATTR10,
       HAS.ATTR11,
       HAS.ATTR12,
       HAS.ATTR13,
       HAS.ATTR14,
       HAS.ATTR15,
       HAS.ATTR16,
       HAS.ATTR17,
       HAS.ATTR18,
       HAS.ATTR19,
       HAS.ATTR20,
       HPM.HIRE_TYPE AS HIRE_TYPE_CD,
       CCM.CD_NM AS HIRE_TYPE_NM,
       --
       HAS.PAYMENT_CURR_CD,
       CCM10.CD_NM AS PAYMENT_CUR_NM,
       HAS.SALARY_INFO_TYPE,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'HR_SALARY_INFO_TYPE' AND CD = HAS.SALARY_INFO_TYPE AND COMP_CD = 'N000' AND INV_ORG_ID = -1 AND LANG_CD = 'KO') SALARY_INFO_TYPE_NM,
       HAS.PS_AREA,
       HAS.PS_TYPE,
       HAS.PS_GROUP,
       HAS.PS_LEVEL,
       HAS.PEAK_TYPE,
       
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'PayScaleArea' AND CD = HAS.PS_AREA AND COMP_CD = 'N000' AND INV_ORG_ID = -1 AND LANG_CD = 'KO') PS_AREA_NM,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'PayScaleType' AND CD = HAS.PS_TYPE AND COMP_CD = 'N000' AND INV_ORG_ID = -1 AND LANG_CD = 'KO') PS_TYPE_NM,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'PayScaleGroup' AND CD = HAS.PS_GROUP AND COMP_CD = 'N000' AND INV_ORG_ID = -1 AND LANG_CD = 'KO') PS_GROUP_NM,
       
       HAS.TODO_TRGT_YN,
       HAS.MAIL_SEND_TRGT_YN,
       HPM.SF_USER_ID
  FROM HR_ASG_SALARY HAS
  JOIN HR_PSN_MST HPM
    ON HAS.EMP_ID = HPM.EMP_ID
  JOIN HR_ASG_MST HAM
    ON HAM.EMP_ID = HAS.EMP_ID
  JOIN HR_ORG_MST HOM
    ON HOM.ORG_ID = HAM.ORG_ID
   AND '20221116' >= HOM.EFFCT_STRT_DATE
   AND '20221116' <= HOM.EFFCT_END_DATE    
  LEFT OUTER JOIN CM_USER CU
    ON CU.USER_ID = HAS.UPDT_ID
  -- 李⑥꽭???I/F ?곗씠?곕? 蹂댁뿬二쇰룄濡?  ?섏젙
  -- LEFT OUTER JOIN  ( SELECT EPM.EMP_ID,
  --                          CASE WHEN EB.EVAL_OPEN_DT <= erpapp.db_DATE_TO_CHAR(erpapp.db_SYSDATE(), 'YYYYMMDDHH24MISS') THEN EPM.EVAL_GRD ELSE NULL END  AS EVAL_GRD
  --                     FROM HR_EVAL_PER_MST EPM
  --                    INNER JOIN HR_EVAL_BASIS EB
  --                       ON EPM.EVAL_YEAR = EB.EVAL_YEAR
  --                      AND EPM.COMP_CD = EB.COMP_CD
  --                    WHERE  EPM.EVAL_YEAR = erpapp.db_DATE_TO_CHAR(erpapp.db_add_months(erpapp.db_SYSDATE(),-12) , 'YYYY') 
  --                ) EVAL
  --  ON HAS.EMP_ID = EVAL.EMP_ID
   LEFT OUTER JOIN HR_PSN_EVAL_IF EVAL
        ON EVAL.COMP_CD = 'N000'
    AND EVAL.EMP_ID = HAS.EMP_ID
--    AND EVAL.EVAL_YEAR = ERPAPP.db_DATE_TO_CHAR(ERPAPP.db_add_months(ERPAPP.db_TO_DATE(@EFFCT_DATE, 'YYYYMMDD'),-12) , 'YYYY') 
    AND EVAL.EVAL_YEAR = date_format(date_add(date_format('20221116', '%Y%m%d'), interval -12 month) , '%Y') 
   LEFT OUTER JOIN CM_CODE_M CCM
     ON CCM.COMP_CD = 'N000'
    AND CCM.CD = HPM.HIRE_TYPE
    AND CCM.GRP_CD = 'cust_EmploymentType'
    AND CCM.LANG_CD = 'KO'
  LEFT OUTER JOIN CM_CODE_M CCM10
    ON CCM10.GRP_CD = 'HR_REC_CURR_CD'
   AND CCM10.CD = HAS.PAYMENT_CURR_CD
   AND CCM10.LANG_CD = 'KO'
   AND CCM10.COMP_CD = 'N000'
   AND CCM10.INV_ORG_ID = -1
WHERE        HAS.COMP_CD = 'N000'
   AND '20221116' >= HAM.EFFCT_STRT_DATE
   AND '20221116' <= HAM.EFFCT_END_DATE
   AND '20221116' >= HAS.EFFCT_STRT_DATE
   AND '20221116' <= HAS.EFFCT_END_DATE    
--   AND ERPAPP.db_nvl_char(HPM.RETR_DATE, @EFFCT_DATE) >= HAM.EFFCT_STRT_DATE
   AND CASE WHEN HPM.RETR_DATE IS NULL THEN '20221116'
            WHEN HPM.RETR_DATE = '' THEN '20221116'
            ELSE HPM.RETR_DATE 
       END >= HAM.EFFCT_STRT_DATE
--   AND ERPAPP.db_nvl_char(HPM.RETR_DATE, @EFFCT_DATE) <= HAM.EFFCT_END_DATE   
   AND CASE WHEN HPM.RETR_DATE IS NULL THEN '20221116'
            WHEN HPM.RETR_DATE = '' THEN '20221116'
            ELSE HPM.RETR_DATE 
       END <= HAM.EFFCT_END_DATE
AND (HAM.EMP_STAT_CD IN ('A','D', 'P') OR (HAM.EMP_STAT_CD = 'T' AND HAM.EFFCT_STRT_DATE >= '20221101'))
AND HAM.EMP_TYPE != 'OUT'
AND HAS.PEAK_YN != 'Y'
AND HAM.EMP_TYPE != 'C'
AND        HAS.PAY_STEP_TYPE = 'SAL'
AND 1=1
 ORDER BY HPM.EMP_NO
 limit 0, 10000
/* [BizActor].[DAC_HR_ASG_PAY_STEP_Adhoc].[DAS_HR_RetrievePayStepUpEmpListForSalary] */;
# Time: 2022-11-16T00:35:48.458529Z
# User@Host: erpapp[erpapp] @  [10.2.183.72]  thread_id: 7773410  server_id: 2886939016
# Query_time: 3.453912  Lock_time: 0.000929 Rows_sent: 1  Rows_examined: 129496
SET timestamp=1668558945;
select count(1) from (
SELECT HPM.EMP_NO,
       HPM.EMP_NM,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'cust_JobTitle' AND CD = HAM.JOB_TITLE_CD AND COMP_CD = HPM.COMP_CD AND INV_ORG_ID = -1 AND LANG_CD = 'KO') JOB_NM,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'cust_SupervisorLevel' AND CD = HAM.POSITION_CD AND COMP_CD = HPM.COMP_CD AND INV_ORG_ID = -1 AND LANG_CD = 'KO') POSITION_NM,
       ERPAPP.db_NVL_CHAR(HOM.ORG_FULL_NM, HOM.ORG_NM) AS ORG_FULL_NM,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'cust_EmployeeClass' AND CD = HAM.EMP_TYPE AND COMP_CD = HPM.COMP_CD AND INV_ORG_ID = -1 AND LANG_CD = 'KO') EMP_TYPE_NM,
       HAS.EMP_ID,
       HAS.EFFCT_STRT_DATE,
       HAS.EFFCT_END_DATE,
--       ERPAPP.db_DATE_TO_CHAR(ERPAPP.db_TO_DATE(HAS.EFFCT_STRT_DATE, 'YYYYMMDD'), ERPAPP.db_NVL_CHAR(@DATE_FORMAT, 'YYYYMMDD')) AS STRT_DATE,
       ERPAPP.db_DATE_TO_CHAR(date_format(HAS.EFFCT_STRT_DATE, '%Y%m%d'), CASE WHEN 'YYYY/MM/DD' IS NULL THEN 'YYYYMMDD'
                                                                               WHEN 'YYYY/MM/DD' = '' THEN 'YYYYMMDD'
                                                                               ELSE 'YYYY/MM/DD' 
                                                                          END) AS STRT_DATE,
--       ERPAPP.db_DATE_TO_CHAR(ERPAPP.db_TO_DATE(HAS.EFFCT_END_DATE, 'YYYYMMDD'), ERPAPP.db_NVL_CHAR(@DATE_FORMAT, 'YYYYMMDD')) AS END_DATE,
       ERPAPP.db_DATE_TO_CHAR(date_format(HAS.EFFCT_END_DATE, '%Y%m%d'), CASE WHEN 'YYYY/MM/DD' IS NULL THEN 'YYYYMMDD'
                                                                               WHEN 'YYYY/MM/DD' = '' THEN 'YYYYMMDD'
                                                                               ELSE 'YYYY/MM/DD' 
                                                                          END) AS END_DATE,
       HAS.PRE_CHNG_DATE,
       HAS.PAY_STEP_TYPE,
       HAM.JOB_GRADE_SENIORITY,
       '' as PAY_STEP_CD,     
       HAS.PAY_STEP_ID, 
       HAS.JOB_PAY_STEP_ID,
       EVAL.EVAL_GRD,
       HAS.SALARY,
       HAS.BASE_AMT,
       HAS.PAY_VALUE1,
       HAS.STNDRD_AMT,
       HAS.PAY_VALUE2,
       HAS.PAY_VALUE3,
       HAS.MULTI_VAL,
       HAS.CHNG_RSN_CD,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'HR_SAL_CHNG_RSN' AND CD = HAS.CHNG_RSN_CD AND COMP_CD = 'N000' AND INV_ORG_ID = -1 AND LANG_CD = 'KO') CHNG_RSN_NM,
       HAS.CHNG_DESC,
       HAS.COMP_CD,
       CU.EMP_NM AS UPDT_NM,
--       ERPAPP.db_DATE_TO_CHAR(ERPAPP.db_TO_DATE(HAS.UPDT_DT, 'YYYYMMDDHH24MISS'), ERPAPP.db_CONCAT(ERPAPP.db_NVL_CHAR(@DATE_FORMAT, 'YYYYMMDD'), ' HH24:MI:SS')) AS UPDT_DT,
       ERPAPP.db_DATE_TO_CHAR(date_format(HAS.UPDT_DT, '%Y%m%d%H%i%s'), concat(CASE WHEN 'YYYY/MM/DD' IS NULL THEN 'YYYYMMDD'
                                                                                    WHEN 'YYYY/MM/DD' = '' THEN 'YYYYMMDD'
                                                                                    ELSE 'YYYY/MM/DD' 
                                                                               END, ' HH24:MI:SS')) AS UPDT_DT,
       HAS.LOCK_SEQ,
       HAS.FAC_TYPE,
       HAS.ATTR1,
       HAS.ATTR2,
       HAS.ATTR3,
       HAS.ATTR4,
       HAS.ATTR5,
       HAS.ATTR6,
       HAS.ATTR7,
       HAS.ATTR8,
       HAS.ATTR9,
       HAS.ATTR10,
       HAS.ATTR11,
       HAS.ATTR12,
       HAS.ATTR13,
       HAS.ATTR14,
       HAS.ATTR15,
       HAS.ATTR16,
       HAS.ATTR17,
       HAS.ATTR18,
       HAS.ATTR19,
       HAS.ATTR20,
       HPM.HIRE_TYPE AS HIRE_TYPE_CD,
       CCM.CD_NM AS HIRE_TYPE_NM,
       --
       HAS.PAYMENT_CURR_CD,
       CCM10.CD_NM AS PAYMENT_CUR_NM,
       HAS.SALARY_INFO_TYPE,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'HR_SALARY_INFO_TYPE' AND CD = HAS.SALARY_INFO_TYPE AND COMP_CD = 'N000' AND INV_ORG_ID = -1 AND LANG_CD = 'KO') SALARY_INFO_TYPE_NM,
       HAS.PS_AREA,
       HAS.PS_TYPE,
       HAS.PS_GROUP,
       HAS.PS_LEVEL,
       HAS.PEAK_TYPE,
       
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'PayScaleArea' AND CD = HAS.PS_AREA AND COMP_CD = 'N000' AND INV_ORG_ID = -1 AND LANG_CD = 'KO') PS_AREA_NM,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'PayScaleType' AND CD = HAS.PS_TYPE AND COMP_CD = 'N000' AND INV_ORG_ID = -1 AND LANG_CD = 'KO') PS_TYPE_NM,
       (SELECT CD_NM FROM CM_CODE_M WHERE GRP_CD = 'PayScaleGroup' AND CD = HAS.PS_GROUP AND COMP_CD = 'N000' AND INV_ORG_ID = -1 AND LANG_CD = 'KO') PS_GROUP_NM,
       
       HAS.TODO_TRGT_YN,
       HAS.MAIL_SEND_TRGT_YN,
       HPM.SF_USER_ID
  FROM HR_ASG_SALARY HAS
  JOIN HR_PSN_MST HPM
    ON HAS.EMP_ID = HPM.EMP_ID
  JOIN HR_ASG_MST HAM
    ON HAM.EMP_ID = HAS.EMP_ID
  JOIN HR_ORG_MST HOM
    ON HOM.ORG_ID = HAM.ORG_ID
   AND '20221116' >= HOM.EFFCT_STRT_DATE
   AND '20221116' <= HOM.EFFCT_END_DATE    
  LEFT OUTER JOIN CM_USER CU
    ON CU.USER_ID = HAS.UPDT_ID
  -- 李⑥꽭???I/F ?곗씠?곕? 蹂댁뿬二쇰룄濡?  ?섏젙
  -- LEFT OUTER JOIN  ( SELECT EPM.EMP_ID,
  --                          CASE WHEN EB.EVAL_OPEN_DT <= erpapp.db_DATE_TO_CHAR(erpapp.db_SYSDATE(), 'YYYYMMDDHH24MISS') THEN EPM.EVAL_GRD ELSE NULL END  AS EVAL_GRD
  --                     FROM HR_EVAL_PER_MST EPM
  --                    INNER JOIN HR_EVAL_BASIS EB
  --                       ON EPM.EVAL_YEAR = EB.EVAL_YEAR
  --                      AND EPM.COMP_CD = EB.COMP_CD
  --                    WHERE  EPM.EVAL_YEAR = erpapp.db_DATE_TO_CHAR(erpapp.db_add_months(erpapp.db_SYSDATE(),-12) , 'YYYY') 
  --                ) EVAL
  --  ON HAS.EMP_ID = EVAL.EMP_ID
   LEFT OUTER JOIN HR_PSN_EVAL_IF EVAL
        ON EVAL.COMP_CD = 'N000'
    AND EVAL.EMP_ID = HAS.EMP_ID
--    AND EVAL.EVAL_YEAR = ERPAPP.db_DATE_TO_CHAR(ERPAPP.db_add_months(ERPAPP.db_TO_DATE(@EFFCT_DATE, 'YYYYMMDD'),-12) , 'YYYY') 
    AND EVAL.EVAL_YEAR = date_format(date_add(date_format('20221116', '%Y%m%d'), interval -12 month) , '%Y') 
   LEFT OUTER JOIN CM_CODE_M CCM
     ON CCM.COMP_CD = 'N000'
    AND CCM.CD = HPM.HIRE_TYPE
    AND CCM.GRP_CD = 'cust_EmploymentType'
    AND CCM.LANG_CD = 'KO'
  LEFT OUTER JOIN CM_CODE_M CCM10
    ON CCM10.GRP_CD = 'HR_REC_CURR_CD'
   AND CCM10.CD = HAS.PAYMENT_CURR_CD
   AND CCM10.LANG_CD = 'KO'
   AND CCM10.COMP_CD = 'N000'
   AND CCM10.INV_ORG_ID = -1
WHERE        HAS.COMP_CD = 'N000'
   AND '20221116' >= HAM.EFFCT_STRT_DATE
   AND '20221116' <= HAM.EFFCT_END_DATE
   AND '20221116' >= HAS.EFFCT_STRT_DATE
   AND '20221116' <= HAS.EFFCT_END_DATE    
--   AND ERPAPP.db_nvl_char(HPM.RETR_DATE, @EFFCT_DATE) >= HAM.EFFCT_STRT_DATE
   AND CASE WHEN HPM.RETR_DATE IS NULL THEN '20221116'
            WHEN HPM.RETR_DATE = '' THEN '20221116'
            ELSE HPM.RETR_DATE 
       END >= HAM.EFFCT_STRT_DATE
--   AND ERPAPP.db_nvl_char(HPM.RETR_DATE, @EFFCT_DATE) <= HAM.EFFCT_END_DATE   
   AND CASE WHEN HPM.RETR_DATE IS NULL THEN '20221116'
            WHEN HPM.RETR_DATE = '' THEN '20221116'
            ELSE HPM.RETR_DATE 
       END <= HAM.EFFCT_END_DATE
AND (HAM.EMP_STAT_CD IN ('A','D', 'P') OR (HAM.EMP_STAT_CD = 'T' AND HAM.EFFCT_STRT_DATE >= '20221101'))
AND HAM.EMP_TYPE != 'OUT'
AND HAS.PEAK_YN != 'Y'
AND HAM.EMP_TYPE != 'C'
AND        HAS.PAY_STEP_TYPE = 'SAL'
AND 1=1
) t
/* [BizActor].[DAC_HR_ASG_PAY_STEP_Adhoc].[DAS_HR_RetrievePayStepUpEmpListForSalary] */;
# Time: 2022-11-16T00:36:02.143005Z
# User@Host: erpapp[erpapp] @  [10.2.183.84]  thread_id: 7770571  server_id: 2886939016
# Query_time: 3.192111  Lock_time: 0.001671 Rows_sent: 30  Rows_examined: 4048
SET timestamp=1668558958;
SELECT CASE WHEN COUNT(D.CODE) OVER (PARTITION BY D.DISPLAYNAME_TEMP) >1 THEN  ERPAPP.DB_CONCAT5(D.DISPLAYNAME_TEMP ,'(' , D.EMAIL_ADDR , ')', '')  ELSE D.DISPLAYNAME_TEMP  END AS DISPLAYNAME
          ,D.*
FROM (
      SELECT
             ROW_NUMBER() OVER(ORDER BY HPM.EMP_NM ASC) AS ROW_NUM
      ,COUNT(1) OVER() AS TOTAL_CNT
      ,HPM.EMP_ID AS CODE
      ,ERPAPP.DB_CONCAT7(CASE WHEN UPPER(HPM.EMP_NM) LIKE CONCAT('%',UPPER('??),'%') THEN COALESCE(HPM.EMP_NM,'UNDEFINED') 
      WHEN UPPER(HPM.ENG_EMP_NM) LIKE CONCAT('%',UPPER('??),'%') THEN COALESCE(HPM.ENG_EMP_NM,'UNDEFINED') 
     WHEN UPPER(HPM.CHN_EMP_NM) LIKE CONCAT('%',UPPER('??),'%') THEN COALESCE(HPM.CHN_EMP_NM,'UNDEFINED') ELSE HPM.EMP_NM END
     , ' ' , CCM2.CD_NM
     , '/' , 
        CASE WHEN 'KO' = 'EN' THEN COALESCE(HOM.ENG_ORG_NM,'UNDEFINED')
                  ELSE HOM.ORG_NM END
      -- 2019.07.30 異붽?
      , CASE WHEN HPM.EMP_STAT_CD = 'T' THEN ERPAPP.DB_CONCAT('/', CCM5.CD_NM ) ELSE '' END
      , ''
      ) AS DISPLAYNAME_TEMP
       
      ,HPM.EMP_NO AS ATTR1              -- ?щ쾲
      ,HOM.ORG_ID AS ATTR2            -- 議곗쭅ID
      ,ERPAPP.DB_CONCAT3(CASE WHEN 'KO' = 'EN' THEN COALESCE(HPM.ENG_EMP_NM,'UNDEFINED')
         ELSE HPM.EMP_NM END
        , ' ' , CCM2.CD_NM) AS ATTR3    -- ?대쫫吏곴툒    
          ,CASE WHEN 'KO' = 'EN' THEN COALESCE(HOM.ENG_ORG_NM,'UNDEFINED')
           ELSE HOM.ORG_NM END AS ATTR4   
      ,HAM.EMP_STAT_CD AS ATTR5    -- ?ъ썝?곹깭  
      ,CCM2.CD_NM AS ATTR6 -- ?몄묶
      ,HOM.ORG_FULL_NM AS ATTR7 -- 遺?쒕챸(FULL NAME)
      ,CCM3.CD_NM AS ATTR8 -- 吏곷Т
      ,CCM4.CD_NM AS ATTR9 -- 吏곷Т?덈꺼
      ,CCM5.CD_NM AS ATTR10  -- ?ъ쭅援щ텇
      ,CCM6.CD_NM AS ATTR11  -- 怨좎슜?좏삎
      ,CU.USER_ID AS ATTR12 -- USER_ID
      ,HPM.RETR_DATE AS ATTR13 -- ?댁쭅?쇱옄
      ,CASE WHEN 'KO' = 'EN' THEN COALESCE(HPM.ENG_EMP_NM,'UNDEFINED')
                     ELSE HPM.EMP_NM END AS ATTR14             -- ?깅챸
      ,'' AS ATTR15
      ,HPM.EMP_NM 
      ,HPM.EMAIL_ADDR
      ,HPM.MOBL_TEL_NO
  FROM HR_PSN_MST HPM
  JOIN HR_ASG_MST HAM
    ON HPM.EMP_ID = HAM.EMP_ID    
  JOIN HR_ORG_MST HOM
    ON HAM.ORG_ID = HOM.ORG_ID
  JOIN HR_ORG_COMPANY HOC
    ON HPM.COMP_CD = HOC.COMP_CD
  LEFT OUTER JOIN CM_USER CU
    ON HPM.COMP_CD = CU.COMP_CD
  AND HPM.EMP_ID = CU.EMP_ID
    -- 吏곸쐞--
  LEFT OUTER JOIN CM_CODE_M CCM2
    ON HAM.JOB_TITLE_CD = CCM2.CD
   AND CCM2.GRP_CD   = 'cust_JobTitle'
   AND CCM2.LANG_CD  = 'KO'
   AND CCM2.COMP_CD  = HPM.COMP_CD 
    -- 吏곷Т --
  LEFT OUTER JOIN CM_CODE_M CCM3
     ON HAM.JOB_CD = CCM3.CD
   AND CCM3.GRP_CD   = 'JobClassification'
   AND CCM3.LANG_CD  = 'KO'
   AND CCM3.COMP_CD  = HPM.COMP_CD
    -- 吏곷Т?덈꺼 --
  LEFT OUTER JOIN CM_CODE_M CCM4
    ON HAM.JOB_GRADE_CD = CCM4.CD
   AND CCM4.GRP_CD   = 'cust_JobGrade'
   AND CCM4.LANG_CD  = 'KO'
   AND CCM4.COMP_CD  = HPM.COMP_CD
    -- ?ъ쭅援щ텇 --
  LEFT OUTER JOIN CM_CODE_M CCM5
    ON HPM.EMP_STAT_CD = CCM5.CD
   AND CCM5.GRP_CD   = 'employee-status'
   AND CCM5.LANG_CD  = 'KO'
   AND CCM5.COMP_CD  = '*'
    -- 怨좎슜?좏삎 --
  LEFT OUTER JOIN CM_CODE_M CCM6
    ON HPM.HIRE_TYPE = CCM6.CD
   AND CCM6.GRP_CD   = 'cust_EmploymentType'
   AND CCM6.LANG_CD  = 'KO'
   AND CCM6.COMP_CD  = HPM.COMP_CD
WHERE ERPAPP.DB_DATE_TO_CHAR(ERPAPP.DB_SYSDATE(), 'YYYYMMDD') BETWEEN HAM.EFFCT_STRT_DATE AND HAM.EFFCT_END_DATE 
-- AND (CASE WHEN HAM.EMP_STAT_CD = 'T' THEN HAM.EFFCT_STRT_DATE ELSE ERPAPP.DB_DATE_TO_CHAR(ERPAPP.DB_SYSDATE(), 'YYYYMMDD') END ) BETWEEN HOM.EFFCT_STRT_DATE AND HOM.EFFCT_END_DATE 
   AND (CASE WHEN HAM.EMP_STAT_CD = 'T' 
             THEN HPM.RETR_DATE
             ELSE ERPAPP.DB_DATE_TO_CHAR(ERPAPP.DB_SYSDATE(), 'YYYYMMDD') 
        END ) BETWEEN HOM.EFFCT_STRT_DATE AND HOM.EFFCT_END_DATE 
   AND HPM.COMP_CD = 'N000'
AND -- HAM.EMP_STAT_CD IN ( 'C', 'S', 'T') -- ?ъ쭅/?댁쭅/?댁쭅
-- 2021.06.04 ?ъ슜?먯“?뚯떆 EMP_STAT_CD ?뚮Ц??議고쉶 ?덈릺??臾몄젣 ?닿껐?섍린 ?꾪븳 ?꾩떆 肄붾뱶
-- CASE WHEN HPM.COMP_CD IN ('ETC0', 'N000') THEN
--             CASE WHEN HAM.EMP_STAT_CD = 'A' THEN 'C'
--                  WHEN HAM.EMP_STAT_CD = 'P' THEN 'S'
--                  ELSE HAM.EMP_STAT_CD
--             END
--     ELSE HAM.EMP_STAT_CD
-- END IN ( 'C', 'S', 'T')
HAM.EMP_STAT_CD IN ( 'A', 'P', 'T')
AND (    HPM.EMP_NO = '?? 
   OR UPPER(HPM.EMP_NM) LIKE UPPER(ERPAPP.DB_CONCAT3('%', '??, '%' ))
   OR UPPER(HPM.ENG_EMP_NM) LIKE UPPER(ERPAPP.DB_CONCAT3('%', '??,'%'))
)
AND         1=1 
) D
WHERE ROW_NUM BETWEEN ( (1 * 30) - (30-1)) AND 1 * 30
ORDER BY EMP_NM ASC
/* [BizActor].[DAC_HR_CM_COMMON_Adhoc].[DAS_HR_RetrieveEmpList] */;
