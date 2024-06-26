# Time: 2022-09-14T02:13:09.761228Z
# User@Host: erpapp[erpapp] @  [10.2.183.106]  thread_id: 4155596  server_id: 4282968835
# Query_time: 7.037896  Lock_time: 0.001327 Rows_sent: 1  Rows_examined: 168957
use ERPAPP;
SET timestamp=1663121582;
SELECT COALESCE((
        SELECT count(*) cnt
          FROM HR_PSN_RETR_SEP_MST
         WHERE COMP_CD = 'C000'
           AND RETR_SEP_STAT_CD = 'S'
         GROUP BY COMP_CD
             ) ,0) AS ACNT,
      COALESCE((
      SELECT count(*)
        FROM
            ( 
          SELECT  HPM.EMP_ID
                , HPM.RETR_DATE
                , SETUP.RETR_SEP_SETUP_ID
                , CASE WHEN HPM.HIRE_TYPE = SETUP.HIRE_TYPE THEN 1 
                    WHEN HPM.EMP_TYPE = SETUP.EMP_TYPE THEN 2
                    WHEN SETUP.HIRE_TYPE = '*' AND SETUP.EMP_TYPE = '*' THEN 3
                  ELSE NULL
                  END AS ORDER_NUM
                , CASE SETUP.RETR_SEP_JOB_TYPE  
                    WHEN 'D' THEN db_date_to_char(db_date_add('DD', db_to_number_0(SETUP.WT_PERIOD) , db_to_date(HPM.RETR_DATE, 'YYYYMMDD') ), 'YYYYMMDD') -- ?좏삎??D'?대㈃?좎쭨瑜퍪DD
                    WHEN 'M' THEN db_date_to_char(db_date_add('MM', db_to_number_0(SETUP.WT_PERIOD) , db_to_date(HPM.RETR_DATE, 'YYYYMMDD') ), 'YYYYMMDD') -- ?좏삎??M'?대㈃媛쒖썡?쁀DD
                    ELSE db_date_to_char(db_date_add('D', -1, db_date_add('MM', 2, db_to_date(db_concat(db_substr(HPM.RETR_DATE, 1,6 ) , '01'), 'YYYYMMDD'))), 'YYYYMMDD') -- ?좏삎??L' ?대㈃?듭썡留덉?留됱씪
                  END AS SEP_DATE
                , MIN(CASE WHEN HPM.HIRE_TYPE = SETUP.HIRE_TYPE THEN 1 
                           WHEN HPM.EMP_TYPE = SETUP.EMP_TYPE THEN 2
                           WHEN SETUP.HIRE_TYPE = '*' AND SETUP.EMP_TYPE = '*' THEN 3
                      ELSE NULL END ) OVER(PARTITION BY HPM.EMP_ID) AS TARGET_NUM
                , SETUP.WT_PERIOD
            FROM HR_PSN_MST HPM
            LEFT OUTER JOIN HR_PSN_RETR_SEP_SETUP SETUP
              ON HPM.COMP_CD = SETUP.COMP_CD
           WHERE HPM.COMP_CD = 'C000'
             AND HPM.EMP_STAT_CD = 'T'
             AND HPM.RETR_DATE >= SETUP.STRT_DATE
             AND NOT EXISTS ( SELECT 1 
                                FROM HR_PSN_RETR_SEP_MST HPR
                               WHERE HPR.COMP_CD = HPM.COMP_CD
                                 AND HPR.EMP_ID = HPM.EMP_ID 
                             )    
            ) SEP
       WHERE SEP.ORDER_NUM = SEP.TARGET_NUM -- 怨좎슜?좏삎媛숈?寃껋쓣 癒쇱? ?섑뻾?섍퀬, 洹몃떎?뚯씠 ?ъ썝?좏삎, ?대떦 ?좏삎???놁쑝硫??쇰컲 ?뗭뾽(*)???섑뻾??
         AND db_date_to_char(db_sysdate(), 'YYYYMMDD')  >=  SEP.SEP_DATE
      ),0) AS BCNT,
   -- ?덉쇅?몄썝 --
     COALESCE((
      SELECT count(*)
          FROM
              ( 
            SELECT  HPM.EMP_ID
                  , HPM.RETR_DATE
                  , SETUP.RETR_SEP_SETUP_ID
                  , CASE WHEN HPM.HIRE_TYPE = SETUP.HIRE_TYPE THEN 1 
                      WHEN HPM.EMP_TYPE = SETUP.EMP_TYPE THEN 2
                      WHEN SETUP.HIRE_TYPE = '*' AND SETUP.EMP_TYPE = '*' THEN 3
                    ELSE NULL
                    END AS ORDER_NUM
                  , CASE SETUP.RETR_SEP_JOB_TYPE  
                      WHEN 'D' THEN db_date_to_char(db_date_add('DD', db_to_number_0(SETUP.WT_PERIOD) , db_to_date(HPM.RETR_DATE, 'YYYYMMDD') ), 'YYYYMMDD') -- ?좏삎??D'?대㈃?좎쭨瑜퍪DD
                    WHEN 'M' THEN db_date_to_char(db_date_add('MM', db_to_number_0(SETUP.WT_PERIOD) , db_to_date(HPM.RETR_DATE, 'YYYYMMDD') ), 'YYYYMMDD') -- ?좏삎??M'?대㈃媛쒖썡?쁀DD
                    ELSE db_date_to_char(db_date_add('D', -1, db_date_add('MM', 2, db_to_date(db_concat(db_substr(HPM.RETR_DATE, 1,6 ) , '01'), 'YYYYMMDD'))), 'YYYYMMDD') -- ?좏삎??L' ?대㈃?듭썡留덉?留됱씪
                    END AS SEP_DATE
                  , MIN(CASE WHEN HPM.HIRE_TYPE = SETUP.HIRE_TYPE THEN 1 
                             WHEN HPM.EMP_TYPE = SETUP.EMP_TYPE THEN 2
                             WHEN SETUP.HIRE_TYPE = '*' AND SETUP.EMP_TYPE = '*' THEN 3
                        ELSE NULL END ) OVER(PARTITION BY HPM.EMP_ID) AS TARGET_NUM
                  , SETUP.WT_PERIOD
              FROM HR_PSN_MST HPM
              LEFT OUTER JOIN HR_PSN_RETR_SEP_SETUP SETUP
                ON HPM.COMP_CD = SETUP.COMP_CD
             WHERE HPM.COMP_CD = 'C000'
               AND HPM.EMP_STAT_CD = 'T'
               AND HPM.RETR_DATE >= SETUP.STRT_DATE
         -- ?대? 遺꾨━ ?뚯씠釉붿뿉 ?ㅼ뼱媛꾩궗?뚯? ?쒖쇅 
               AND NOT EXISTS ( SELECT 1 
                                  FROM HR_PSN_RETR_SEP_MST HPR
                                 WHERE HPR.COMP_CD = HPM.COMP_CD
                                   AND HPR.EMP_ID = HPM.EMP_ID 
                               )   
              ) SEP
         WHERE SEP.ORDER_NUM = SEP.TARGET_NUM -- 怨좎슜?좏삎媛숈?寃껋쓣 癒쇱? ?섑뻾?섍퀬, 洹몃떎?뚯씠 ?ъ썝?좏삎, ?대떦 ?좏삎???놁쑝硫??쇰컲 ?뗭뾽(*)???섑뻾??
           AND db_date_to_char(db_sysdate(), 'YYYYMMDD')  >=  SEP.SEP_DATE
          -- ?덉쇅湲곌컙?닿굅???덉쇅?먯씤?? --              
           AND (EXISTS ( SELECT 1
                           FROM HR_PSN_RETR_SEP_EXCEPT RSE
                          WHERE RSE.COMP_CD = 'C000'
                            AND RSE.RETR_SEP_EXCEPT_TYPE = 'P'
                            AND RSE.RETR_SEP_SETUP_ID = SEP.RETR_SEP_SETUP_ID
                            AND RSE.EMP_ID  = SEP.EMP_ID
                            AND db_date_to_char(db_sysdate(), 'YYYYMMDD') BETWEEN RSE.STRT_DATE AND RSE.END_DATE
                           )
            OR EXISTS ( SELECT 1
                          FROM HR_PSN_RETR_SEP_EXCEPT RSE
                         WHERE RSE.COMP_CD = 'C000'
                           AND RSE.RETR_SEP_EXCEPT_TYPE = 'A'
                           AND RSE.RETR_SEP_SETUP_ID = SEP.RETR_SEP_SETUP_ID
                           AND SEP.RETR_DATE BETWEEN RSE.STRT_DATE AND RSE.END_DATE
                      ))
     ) ,0) AS CCNT,
     -- 蹂듭썝?몄썝 --
   COALESCE((
      SELECT COUNT(*) CNT
        FROM HR_PSN_RETR_SEP_MST RSM
       WHERE COMP_CD = 'C000'
         AND RETR_SEP_STAT_CD = 'R'
       GROUP BY COMP_CD 
    ),0)  AS DCNT
FROM DUAL
/* [BizActor].[DAC_HR_PSN_RETR_SEP_MST_Adhoc].[DAS_HR_RetrieveRetrSepReport] */;
