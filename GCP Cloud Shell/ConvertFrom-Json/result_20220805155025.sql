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
WHERE  ROW_NUM BETWEEN ((8 * 10000) - (10000 - 1)) AND 8 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:04:19.190537Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 10.075329  Lock_time: 0.001061 Rows_sent: 10000  Rows_examined: 26314240
SET timestamp=1659521049;
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
WHERE  ROW_NUM BETWEEN ((9 * 10000) - (10000 - 1)) AND 9 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:04:34.263744Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 10.026331  Lock_time: 0.000841 Rows_sent: 10000  Rows_examined: 26314240
SET timestamp=1659521064;
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
WHERE  ROW_NUM BETWEEN ((10 * 10000) - (10000 - 1)) AND 10 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:04:48.642159Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 9.785035  Lock_time: 0.000736 Rows_sent: 2790  Rows_examined: 26314240
SET timestamp=1659521078;
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
WHERE  ROW_NUM BETWEEN ((11 * 10000) - (10000 - 1)) AND 11 * 10000
/* [BizActor].[DAC_HR_PSN_IF_AddressInfo_Adhoc].[DAS_HR_RetrieveAddressPreRcvListCUN] */;
# Time: 2022-08-03T10:04:58.722154Z
# User@Host: erpapp[erpapp] @  [10.2.183.27]  thread_id: 2986137  server_id: 1710140860
# Query_time: 8.836214  Lock_time: 0.000741 Rows_sent: 3  Rows_examined: 26211453
SET timestamp=1659521089;
SELECT T.REP_COMP_CD
      ,T.COMP_CD
