            ,COST_CENTER_ID
            ,MGNT_DEPT_ID
            ,MGNT_DEPT_NM
            ,FACILITY_ID
            ,COL_EI_YN 
            ,REFUND_AMT
            ,ITEM_OBJECT_ID
            ,CLASS_OBJECT_ID
            ,KOBES1 
            ,KOBES2
            ,KOBES3
            ,KOBES4
            ,KOBES5
            ,KOBES6
            ,KOBES7
            ,KOBES8
            ,KOBES9
            ,KOBES10
            ,KOBES11
            ,KOBES12
            ,KOBES13
            ,SUM_EXP
            ,COST_CENTER_NM 
            ,TOT_APPLY_CNT
            ,TOT_APPLY_CNT2
            ,TOT_APPLY_CNT3
FROM  WITH_B
WHERE 1 = 1
AND 1=1
ORDER BY COL_SCHD_STRT_DATE DESC
 limit 0, 10
/* [BizActor].[DAC_XLGC_LMS_CLASS_REPORT_MGNT_Adhoc].[DAS_XLGC_LMS_RetrieveClassXpendList] */;
# Time: 2022-11-17T04:49:32.668948Z
# User@Host: erpapp[erpapp] @  [10.2.183.125]  thread_id: 4395729  server_id: 2275959756
# Query_time: 6.841186  Lock_time: 0.000490 Rows_sent: 1  Rows_examined: 8051289
SET timestamp=1668660565;
select count(1) from (
WITH WITH_A AS (
    SELECT     SUM(KOBES1) AS KOBES1
            ,SUM(KOBES2) AS KOBES2
            ,SUM(KOBES3) AS KOBES3
            ,SUM(KOBES4) AS KOBES4
            ,SUM(KOBES5) AS KOBES5
            ,SUM(KOBES6) AS KOBES6
            ,SUM(KOBES7) AS KOBES7
            ,SUM(KOBES8) AS KOBES8
            ,SUM(KOBES9) AS KOBES9
            ,SUM(KOBES10) AS KOBES10
            ,SUM(KOBES11) AS KOBES11
            ,SUM(KOBES12) AS KOBES12
            ,SUM(KOBES13) AS KOBES13
            ,SUM(SUM_EXP) AS SUM_EXP
            ,SAP_CLASS_CODE
            ,SAP_ACC_NAME
            ,COST_CENTER_NAME
    FROM     XLGC_LMS_CLASS_XPEND_RCV_IF 
    GROUP BY SAP_CLASS_CODE
            ,COST_CENTER_NAME
            ,SAP_ACC_NAME
),
/*
WHERE */
WITH_B AS (
    SELECT   G.CATEGORY_NM_KO AS CATEGORY_NM
            ,C.SCHD_TITLE
            ,D.SAP_ACC_NAME
            ,C.COL_SCHD_STRT_DATE 
            ,C.COL_SCHD_END_DATE 
            -- ,C.CLASS_DAYS
            ,C.COL_EI_HOURS 
            ,C.COST_CENTER_ID
            ,C.MGNT_DEPT_ID
            ,(
                SELECT  ORG_NM 
                FROM    HR_ORG_MST ORG 
                WHERE   ORG.HR_ORG_CD = C.MGNT_DEPT_ID 
                AND     DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN ORG.EFFCT_STRT_DATE AND ORG.EFFCT_END_DATE
             )  AS MGNT_DEPT_NM
            ,C.FACILITY_ID
            ,C.COL_EI_YN 
            ,F.REFUND_AMT
            ,E.ITEM_OBJECT_ID
            ,C.CLASS_OBJECT_ID
            ,D.KOBES1 
            ,D.KOBES2
            ,D.KOBES3
            ,D.KOBES4
            ,D.KOBES5
            ,D.KOBES6
            ,D.KOBES7
            ,D.KOBES8
            ,D.KOBES9
            ,D.KOBES10
            ,D.KOBES11
            ,D.KOBES12
            ,D.KOBES13
            ,D.SUM_EXP
            ,C.COST_CENTER_NM 
            ,(
                SELECT    COUNT(1)
                FROM    XLGC_LMS_STUDENT_MGNT X
                WHERE    X.CPNT_ID = C.CPNT_ID 
                AND     X.CPNT_TYP_ID = C.CPNT_TYP_ID 
                AND     X.SCHD_ID = C.SCHD_ID
                AND        X.ENRL_STAT_ID IN ('ENROLL')
             )  AS TOT_APPLY_CNT
            ,(
                SELECT    COUNT(1)
                FROM    XLGC_LMS_STUDENT_MGNT X
                       ,HR_ASG_MST ASG
                WHERE    X.CPNT_ID = C.CPNT_ID 
                AND     X.CPNT_TYP_ID = C.CPNT_TYP_ID 
                AND     X.SCHD_ID = C.SCHD_ID
                AND     ASG.EMP_ID = X.EMP_ID
                AND     DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN ASG.EFFCT_STRT_DATE AND ASG.EFFCT_END_DATE
                AND     ASG.EMP_TYPE IN('C', 'E')
             )  AS TOT_APPLY_CNT2
            ,(
                SELECT    COUNT(1)
                FROM    XLGC_LMS_STUDENT_MGNT X
                       ,HR_ASG_MST ASG
                WHERE    X.CPNT_ID = C.CPNT_ID 
                AND     X.CPNT_TYP_ID = C.CPNT_TYP_ID 
                AND     X.SCHD_ID = C.SCHD_ID
                AND     ASG.EMP_ID = X.EMP_ID
                AND     DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN ASG.EFFCT_STRT_DATE AND ASG.EFFCT_END_DATE
                AND     ASG.EMP_TYPE NOT IN ('C', 'E')
             )    AS TOT_APPLY_CNT3
    FROM ERPAPP.XLGC_LMS_CLASS_MGNT C
    INNER JOIN XLGC_LMS_ITEM_MGNT E 
            ON C.CPNT_ID = E.CPNT_ID 
           AND C.CPNT_TYP_ID = E.CPNT_TYP_ID 
    LEFT OUTER JOIN WITH_A D 
                 ON D.SAP_CLASS_CODE = C.CLASS_OBJECT_ID 
    LEFT OUTER JOIN XLGC_LMS_CLASS_RFND_RCV_IF F 
                 ON F.SAP_CLASS_CODE = C.CLASS_OBJECT_ID
    LEFT OUTER JOIN XLGC_LMS_ITEM_CATEGORY_MGNT H 
                 ON H.CPNT_ID = C.CPNT_ID 
                AND H.CPNT_TYP_ID = C.CPNT_TYP_ID 
    LEFT OUTER JOIN XLGC_LMS_CATEGORY_MGNT G
                 ON G.CATEGORY_ID = H.SUBJ_ID 
                    AND G.COMP_CD = E.COMP_CD
    WHERE 1=1
AND SUBSTR(C.COL_SCHD_STRT_DATE, 1, 4) = '2022'
AND (C.COL_SCHD_STRT_DATE >= '20221017' OR C.COL_SCHD_END_DATE >= '20221017')
AND (C.COL_SCHD_STRT_DATE <= '20221117' OR C.COL_SCHD_END_DATE <= '20221117')
AND 1=1
)
/*
AND */
SELECT    CATEGORY_NM
         ,SCHD_TITLE
         ,SAP_ACC_NAME
            ,COL_SCHD_STRT_DATE 
            ,COL_SCHD_END_DATE 
            -- ,C.CLASS_DAYS
            ,COL_EI_HOURS 
            ,COST_CENTER_ID
            ,MGNT_DEPT_ID
            ,MGNT_DEPT_NM
            ,FACILITY_ID
            ,COL_EI_YN 
            ,REFUND_AMT
            ,ITEM_OBJECT_ID
            ,CLASS_OBJECT_ID
            ,KOBES1 
            ,KOBES2
            ,KOBES3
            ,KOBES4
            ,KOBES5
            ,KOBES6
            ,KOBES7
            ,KOBES8
            ,KOBES9
            ,KOBES10
            ,KOBES11
            ,KOBES12
            ,KOBES13
            ,SUM_EXP
            ,COST_CENTER_NM 
            ,TOT_APPLY_CNT
            ,TOT_APPLY_CNT2
            ,TOT_APPLY_CNT3
FROM  WITH_B
WHERE 1 = 1
AND 1=1
) t
/* [BizActor].[DAC_XLGC_LMS_CLASS_REPORT_MGNT_Adhoc].[DAS_XLGC_LMS_RetrieveClassXpendList] */;
# Time: 2022-11-17T04:49:40.674559Z
# User@Host: erpapp[erpapp] @  [10.2.183.125]  thread_id: 4395729  server_id: 2275959756
# Query_time: 7.895209  Lock_time: 0.000645 Rows_sent: 10  Rows_examined: 8051299
SET timestamp=1668660572;
WITH WITH_A AS (
    SELECT     SUM(KOBES1) AS KOBES1
            ,SUM(KOBES2) AS KOBES2
            ,SUM(KOBES3) AS KOBES3
            ,SUM(KOBES4) AS KOBES4
            ,SUM(KOBES5) AS KOBES5
            ,SUM(KOBES6) AS KOBES6
            ,SUM(KOBES7) AS KOBES7
            ,SUM(KOBES8) AS KOBES8
            ,SUM(KOBES9) AS KOBES9
            ,SUM(KOBES10) AS KOBES10
            ,SUM(KOBES11) AS KOBES11
            ,SUM(KOBES12) AS KOBES12
            ,SUM(KOBES13) AS KOBES13
            ,SUM(SUM_EXP) AS SUM_EXP
            ,SAP_CLASS_CODE
            ,SAP_ACC_NAME
            ,COST_CENTER_NAME
    FROM     XLGC_LMS_CLASS_XPEND_RCV_IF 
    GROUP BY SAP_CLASS_CODE
            ,COST_CENTER_NAME
            ,SAP_ACC_NAME
),
/*
WHERE */
WITH_B AS (
    SELECT   G.CATEGORY_NM_KO AS CATEGORY_NM
            ,C.SCHD_TITLE
            ,D.SAP_ACC_NAME
            ,C.COL_SCHD_STRT_DATE 
            ,C.COL_SCHD_END_DATE 
            -- ,C.CLASS_DAYS
            ,C.COL_EI_HOURS 
            ,C.COST_CENTER_ID
            ,C.MGNT_DEPT_ID
            ,(
                SELECT  ORG_NM 
                FROM    HR_ORG_MST ORG 
                WHERE   ORG.HR_ORG_CD = C.MGNT_DEPT_ID 
                AND     DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN ORG.EFFCT_STRT_DATE AND ORG.EFFCT_END_DATE
             )  AS MGNT_DEPT_NM
            ,C.FACILITY_ID
            ,C.COL_EI_YN 
            ,F.REFUND_AMT
            ,E.ITEM_OBJECT_ID
            ,C.CLASS_OBJECT_ID
            ,D.KOBES1 
            ,D.KOBES2
            ,D.KOBES3
            ,D.KOBES4
            ,D.KOBES5
            ,D.KOBES6
            ,D.KOBES7
            ,D.KOBES8
            ,D.KOBES9
            ,D.KOBES10
            ,D.KOBES11
            ,D.KOBES12
            ,D.KOBES13
            ,D.SUM_EXP
            ,C.COST_CENTER_NM 
            ,(
                SELECT    COUNT(1)
                FROM    XLGC_LMS_STUDENT_MGNT X
                WHERE    X.CPNT_ID = C.CPNT_ID 
                AND     X.CPNT_TYP_ID = C.CPNT_TYP_ID 
                AND     X.SCHD_ID = C.SCHD_ID
                AND        X.ENRL_STAT_ID IN ('ENROLL')
             )  AS TOT_APPLY_CNT
            ,(
                SELECT    COUNT(1)
                FROM    XLGC_LMS_STUDENT_MGNT X
                       ,HR_ASG_MST ASG
                WHERE    X.CPNT_ID = C.CPNT_ID 
                AND     X.CPNT_TYP_ID = C.CPNT_TYP_ID 
                AND     X.SCHD_ID = C.SCHD_ID
                AND     ASG.EMP_ID = X.EMP_ID
                AND     DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN ASG.EFFCT_STRT_DATE AND ASG.EFFCT_END_DATE
                AND     ASG.EMP_TYPE IN('C', 'E')
             )  AS TOT_APPLY_CNT2
            ,(
                SELECT    COUNT(1)
                FROM    XLGC_LMS_STUDENT_MGNT X
                       ,HR_ASG_MST ASG
                WHERE    X.CPNT_ID = C.CPNT_ID 
                AND     X.CPNT_TYP_ID = C.CPNT_TYP_ID 
                AND     X.SCHD_ID = C.SCHD_ID
                AND     ASG.EMP_ID = X.EMP_ID
                AND     DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN ASG.EFFCT_STRT_DATE AND ASG.EFFCT_END_DATE
                AND     ASG.EMP_TYPE NOT IN ('C', 'E')
             )    AS TOT_APPLY_CNT3
    FROM ERPAPP.XLGC_LMS_CLASS_MGNT C
    INNER JOIN XLGC_LMS_ITEM_MGNT E 
            ON C.CPNT_ID = E.CPNT_ID 
           AND C.CPNT_TYP_ID = E.CPNT_TYP_ID 
    LEFT OUTER JOIN WITH_A D 
                 ON D.SAP_CLASS_CODE = C.CLASS_OBJECT_ID 
    LEFT OUTER JOIN XLGC_LMS_CLASS_RFND_RCV_IF F 
                 ON F.SAP_CLASS_CODE = C.CLASS_OBJECT_ID
    LEFT OUTER JOIN XLGC_LMS_ITEM_CATEGORY_MGNT H 
                 ON H.CPNT_ID = C.CPNT_ID 
                AND H.CPNT_TYP_ID = C.CPNT_TYP_ID 
    LEFT OUTER JOIN XLGC_LMS_CATEGORY_MGNT G
                 ON G.CATEGORY_ID = H.SUBJ_ID 
                    AND G.COMP_CD = E.COMP_CD
    WHERE 1=1
AND SUBSTR(C.COL_SCHD_STRT_DATE, 1, 4) = '2022'
AND (C.COL_SCHD_STRT_DATE >= '20221017' OR C.COL_SCHD_END_DATE >= '20221017')
AND (C.COL_SCHD_STRT_DATE <= '20221117' OR C.COL_SCHD_END_DATE <= '20221117')
AND 1=1
)
/*
AND */
SELECT    CATEGORY_NM
         ,SCHD_TITLE
         ,SAP_ACC_NAME
            ,COL_SCHD_STRT_DATE 
            ,COL_SCHD_END_DATE 
            -- ,C.CLASS_DAYS
            ,COL_EI_HOURS 
            ,COST_CENTER_ID
            ,MGNT_DEPT_ID
            ,MGNT_DEPT_NM
            ,FACILITY_ID
            ,COL_EI_YN 
            ,REFUND_AMT
            ,ITEM_OBJECT_ID
            ,CLASS_OBJECT_ID
            ,KOBES1 
            ,KOBES2
            ,KOBES3
            ,KOBES4
            ,KOBES5
            ,KOBES6
            ,KOBES7
            ,KOBES8
            ,KOBES9
            ,KOBES10
            ,KOBES11
            ,KOBES12
            ,KOBES13
            ,SUM_EXP
            ,COST_CENTER_NM 
            ,TOT_APPLY_CNT
            ,TOT_APPLY_CNT2
            ,TOT_APPLY_CNT3
FROM  WITH_B
WHERE 1 = 1
AND 1=1
ORDER BY COL_SCHD_STRT_DATE DESC
 limit 0, 10
/* [BizActor].[DAC_XLGC_LMS_CLASS_REPORT_MGNT_Adhoc].[DAS_XLGC_LMS_RetrieveClassXpendList] */;
# Time: 2022-11-17T04:49:48.780216Z
# User@Host: erpapp[erpapp] @  [10.2.183.125]  thread_id: 4395729  server_id: 2275959756
# Query_time: 8.104503  Lock_time: 0.000580 Rows_sent: 1  Rows_examined: 8051289
SET timestamp=1668660580;
select count(1) from (
WITH WITH_A AS (
    SELECT     SUM(KOBES1) AS KOBES1
            ,SUM(KOBES2) AS KOBES2
            ,SUM(KOBES3) AS KOBES3
            ,SUM(KOBES4) AS KOBES4
            ,SUM(KOBES5) AS KOBES5
            ,SUM(KOBES6) AS KOBES6
            ,SUM(KOBES7) AS KOBES7
            ,SUM(KOBES8) AS KOBES8
            ,SUM(KOBES9) AS KOBES9
            ,SUM(KOBES10) AS KOBES10
            ,SUM(KOBES11) AS KOBES11
            ,SUM(KOBES12) AS KOBES12
            ,SUM(KOBES13) AS KOBES13
            ,SUM(SUM_EXP) AS SUM_EXP
            ,SAP_CLASS_CODE
            ,SAP_ACC_NAME
            ,COST_CENTER_NAME
    FROM     XLGC_LMS_CLASS_XPEND_RCV_IF 
    GROUP BY SAP_CLASS_CODE
            ,COST_CENTER_NAME
            ,SAP_ACC_NAME
),
/*
WHERE */
WITH_B AS (
    SELECT   G.CATEGORY_NM_KO AS CATEGORY_NM
            ,C.SCHD_TITLE
            ,D.SAP_ACC_NAME
            ,C.COL_SCHD_STRT_DATE 
            ,C.COL_SCHD_END_DATE 
            -- ,C.CLASS_DAYS
            ,C.COL_EI_HOURS 
            ,C.COST_CENTER_ID
            ,C.MGNT_DEPT_ID
            ,(
                SELECT  ORG_NM 
                FROM    HR_ORG_MST ORG 
                WHERE   ORG.HR_ORG_CD = C.MGNT_DEPT_ID 
                AND     DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN ORG.EFFCT_STRT_DATE AND ORG.EFFCT_END_DATE
             )  AS MGNT_DEPT_NM
            ,C.FACILITY_ID
            ,C.COL_EI_YN 
            ,F.REFUND_AMT
            ,E.ITEM_OBJECT_ID
            ,C.CLASS_OBJECT_ID
            ,D.KOBES1 
            ,D.KOBES2
            ,D.KOBES3
            ,D.KOBES4
            ,D.KOBES5
            ,D.KOBES6
            ,D.KOBES7
            ,D.KOBES8
            ,D.KOBES9
            ,D.KOBES10
            ,D.KOBES11
            ,D.KOBES12
            ,D.KOBES13
            ,D.SUM_EXP
            ,C.COST_CENTER_NM 
            ,(
                SELECT    COUNT(1)
                FROM    XLGC_LMS_STUDENT_MGNT X
                WHERE    X.CPNT_ID = C.CPNT_ID 
                AND     X.CPNT_TYP_ID = C.CPNT_TYP_ID 
                AND     X.SCHD_ID = C.SCHD_ID
                AND        X.ENRL_STAT_ID IN ('ENROLL')
             )  AS TOT_APPLY_CNT
            ,(
                SELECT    COUNT(1)
                FROM    XLGC_LMS_STUDENT_MGNT X
                       ,HR_ASG_MST ASG
                WHERE    X.CPNT_ID = C.CPNT_ID 
                AND     X.CPNT_TYP_ID = C.CPNT_TYP_ID 
                AND     X.SCHD_ID = C.SCHD_ID
                AND     ASG.EMP_ID = X.EMP_ID
                AND     DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN ASG.EFFCT_STRT_DATE AND ASG.EFFCT_END_DATE
                AND     ASG.EMP_TYPE IN('C', 'E')
             )  AS TOT_APPLY_CNT2
            ,(
                SELECT    COUNT(1)
                FROM    XLGC_LMS_STUDENT_MGNT X
                       ,HR_ASG_MST ASG
                WHERE    X.CPNT_ID = C.CPNT_ID 
                AND     X.CPNT_TYP_ID = C.CPNT_TYP_ID 
                AND     X.SCHD_ID = C.SCHD_ID
                AND     ASG.EMP_ID = X.EMP_ID
                AND     DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN ASG.EFFCT_STRT_DATE AND ASG.EFFCT_END_DATE
                AND     ASG.EMP_TYPE NOT IN ('C', 'E')
             )    AS TOT_APPLY_CNT3
    FROM ERPAPP.XLGC_LMS_CLASS_MGNT C
    INNER JOIN XLGC_LMS_ITEM_MGNT E 
            ON C.CPNT_ID = E.CPNT_ID 
           AND C.CPNT_TYP_ID = E.CPNT_TYP_ID 
    LEFT OUTER JOIN WITH_A D 
                 ON D.SAP_CLASS_CODE = C.CLASS_OBJECT_ID 
    LEFT OUTER JOIN XLGC_LMS_CLASS_RFND_RCV_IF F 
                 ON F.SAP_CLASS_CODE = C.CLASS_OBJECT_ID
    LEFT OUTER JOIN XLGC_LMS_ITEM_CATEGORY_MGNT H 
                 ON H.CPNT_ID = C.CPNT_ID 
                AND H.CPNT_TYP_ID = C.CPNT_TYP_ID 
    LEFT OUTER JOIN XLGC_LMS_CATEGORY_MGNT G
                 ON G.CATEGORY_ID = H.SUBJ_ID 
                    AND G.COMP_CD = E.COMP_CD
    WHERE 1=1
AND SUBSTR(C.COL_SCHD_STRT_DATE, 1, 4) = '2022'
AND (C.COL_SCHD_STRT_DATE >= '20221017' OR C.COL_SCHD_END_DATE >= '20221017')
AND (C.COL_SCHD_STRT_DATE <= '20221117' OR C.COL_SCHD_END_DATE <= '20221117')
AND 1=1
)
/*
AND */
SELECT    CATEGORY_NM
         ,SCHD_TITLE
         ,SAP_ACC_NAME
            ,COL_SCHD_STRT_DATE 
            ,COL_SCHD_END_DATE 
            -- ,C.CLASS_DAYS
            ,COL_EI_HOURS 
            ,COST_CENTER_ID
            ,MGNT_DEPT_ID
            ,MGNT_DEPT_NM
            ,FACILITY_ID
            ,COL_EI_YN 
            ,REFUND_AMT
            ,ITEM_OBJECT_ID
            ,CLASS_OBJECT_ID
            ,KOBES1 
            ,KOBES2
            ,KOBES3
            ,KOBES4
            ,KOBES5
            ,KOBES6
            ,KOBES7
            ,KOBES8
            ,KOBES9
            ,KOBES10
            ,KOBES11
            ,KOBES12
            ,KOBES13
            ,SUM_EXP
            ,COST_CENTER_NM 
            ,TOT_APPLY_CNT
            ,TOT_APPLY_CNT2
            ,TOT_APPLY_CNT3
FROM  WITH_B
WHERE 1 = 1
AND 1=1
) t
/* [BizActor].[DAC_XLGC_LMS_CLASS_REPORT_MGNT_Adhoc].[DAS_XLGC_LMS_RetrieveClassXpendList] */;
