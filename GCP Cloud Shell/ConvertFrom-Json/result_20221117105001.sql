2022-11-16T08:22:05.609201Z 4307711 [Note] [MY-013417] [Server] The wait_timeout period was exceeded, the idle time since last command was too long.
2022-11-16T08:22:05.609251Z 4307711 [Note] [MY-010914] [Server] Aborted connection 4307711 to db: 'unconnected' user: 'erpview' host: '10.1.121.193' (Got timeout reading communication packets).
# Time: 2022-11-16T08:23:04.496163Z
# User@Host: erpapp[erpapp] @  [10.2.183.109]  thread_id: 4332370  server_id: 2275959756
# Query_time: 14.793534  Lock_time: 0.001966 Rows_sent: 41  Rows_examined: 106468
SET timestamp=1668586969;
SELECT  DISTINCT
                T.*,
                T.ECNY_DT AS DUTY_STRT_DT,
                DATE_FORMAT(DATE_ADD(T.ECNY_DT, INTERVAL  SPORT_MONTH * 2 DAY), '%Y%m%d') AS DUTY_END_DT,
                       SPORT_MONTH * 2 AS DUTY_MONTH,
                CEIL(DGRI_NUM / 2) AS YEAR_ODR,
                ST.PROC_ACNT_CD,
                ST.PYMNT_CYCLE_CD,
                ST.PYMNT_MTHD_CD,
                ST.REFLCT_STDR_CD,
                ST.FXAMT_TYPE_CD
        FROM (
                SELECT 
                       PY.SEQ_ID,
                       PY.APPLICATION_ID,
                       PY.SPORT_ITEM_CD,
                       C1.CD_NM AS SPORT_ITEM_NM,
                       CAST(CAST(PY.PYMNT_ODR AS DECIMAL) AS CHAR(10)) AS PYMNT_ODR,
                       PY.PYMNT_DT,
                      PY.YEAR_ODR_CD,
                      C5.CD_NM AS YEAR_ODR_NM,
                      PY.SEMATR_CD,
                      C6.CD_NM AS SEMATR_NM,
                       PY.PYMNT_AMT,
                       PY.PRUF_DT,
                       PY.FRMTRM_DT,
                     PY.CLEAR_SLIP_NUM,
                       PY.CHIT_NUM,
                       PY.PYMNT_STAT_CD,
                       C2.CD_NM AS PYMNT_STAT_NM,
                       PY.CHIT_PROC_AT,
                       PY.ERROR_DESC,
                       DATE_FORMAT(PY.CRT_DT,'%Y%m%d') AS CRT_DT,
                       PY.CRT_ID,
                       DATE_FORMAT(PY.UPDT_DT,'%Y%m%d') AS UPDT_DT,
                       PY.UPDT_ID,
                       PY.CNSUL_NO,
                       PY.REAL_PYMNT_DT,
                       SC.JOB_REQ_ID,
                       SC.DGRI_SE_CD,
                       C3.CD_NM AS DGRI_SE_NM,
                       SC.PGM_ID,
                       C4.CD_NM AS PGM_NM,
                       SC.KOR_NAME,
                       XLGC_SLP_CALC_SEMASTER_FUNC(SC.DGRI_STRT_DT, SC.ECNY_DT, SC.PGM_ID) AS DGRI_NUM,
                       SC.ECNY_DT,
                       SC.PYMNT_STRT_DT,
                       SC.PYMNT_END_DT,
                       FLOOR(DATEDIFF(PY_01.SPORT_END_DT, PY_01.SPORT_STRT_DT)) + 1 AS SPORT_MONTH,
                       SC.PURCHASE_ID,
                      PY.RETURN_SLIP_NUM,
                      PY.RETURN_AMT,
                      SC.BIRTH_DATE AS BIRTHDAY
                FROM XLGC_SLP_SCHLSHIP_PYMNT PY
                INNER JOIN XLGC_SLP_SCHLSHIP_INFO SC
                ON (
                       PY.APPLICATION_ID = SC.APPLICATION_ID
                )
                LEFT OUTER JOIN (
                               SELECT 
                                      APPLICATION_ID,
                                      MIN(PYMNT_DT) AS SPORT_STRT_DT,
                                      MAX(PYMNT_DT) AS SPORT_END_DT
                               FROM XLGC_SLP_SCHLSHIP_PYMNT
                               WHERE SPORT_ITEM_CD = '01'
                               GROUP BY APPLICATION_ID
                       ) PY_01
                       ON (
                               SC.APPLICATION_ID = PY_01.APPLICATION_ID
                       )
                LEFT OUTER JOIN CM_CODE_M C1
                ON (
                       C1.GRP_CD = 'XLGC_SLP_SPORT_ITEM_CD'
                       AND C1.CD = PY.SPORT_ITEM_CD
                )
                LEFT OUTER JOIN CM_CODE_M C2
                ON (
                       C2.GRP_CD = 'XLGC_SLP_PYMNT_STAT_CD'
                       AND C2.CD = PY.PYMNT_STAT_CD
                )
                LEFT OUTER JOIN CM_CODE_M C3
                ON (
                       C3.GRP_CD = 'XLGC_SLP__DGRI_SE_CD'
                       AND C3.CD = SC.DGRI_SE_CD
                )
                LEFT OUTER JOIN CM_CODE_M C4
                ON (
                       C4.GRP_CD = 'XLGC_SLP_PROGRM_CD'
                       AND C4.CD = SC.PGM_ID
                )
               LEFT OUTER JOIN CM_CODE_M C5
               ON (
                     C5.GRP_CD = 'XLGC_SLP_YEAR_ODR_CD'
                     AND C5.CD = PY.YEAR_ODR_CD
               )
               LEFT OUTER JOIN CM_CODE_M C6
               ON (
                     C6.GRP_CD = 'XLGC_SLP_SEMATR_CD'
                     AND C6.CD = PY.SEMATR_CD
               )
        ) T LEFT OUTER JOIN XLGC_SLP_PYMNTSTDR_MGNT ST
        ON (
               T.PGM_ID = ST.PGM_ID
               AND T.SPORT_ITEM_CD = ST.SPORT_ITEM_CD
               AND ST.PYMNT_MTHD_CD = '02'
               AND (CASE WHEN ST.DGRI_SE_CD = '01' THEN  'ALL' ELSE ST.DGRI_SE_CD END) IN ('ALL', T.DGRI_SE_CD)
               AND INSTR(ST.YEAR_ODR_CD, CEIL(T.DGRI_NUM / 2)) > 0
               AND INSTR(ST.SEMATR_CD, T.DGRI_NUM) > 0
        )
WHERE KOR_NAME LIKE db_concat3('%', '?댄샇寃?, '%')
ORDER BY PGM_ID, APPLICATION_ID , FRMTRM_DT
/* [BizActor].[DAC_XLGC_SLP_StdPayMgnt].[DAS_XLGC_SLP_RetrievePayList] */;
