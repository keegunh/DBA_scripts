# Time: 2022-12-07T06:36:01.527017Z
# User@Host: erpapp[erpapp] @  [10.2.183.115]  thread_id: 6509456  server_id: 2275959756
# Query_time: 5.840537  Lock_time: 0.000757 Rows_sent: 30693  Rows_examined: 1756077
SET timestamp=1670394955;
SELECT XRPM.CALC_YYYYMM                                               -- ?뺤궛?꾩썡
     , XRPM.SEQNR                                                     -- 李⑥닔
     , XRPM.SEQ_NO                                                    -- ?쒕쾲
     , XRPM.TRANS_DT                                                  -- ?닿??쇱옄
     , XRPM.DIV_CD
     , C2.DIV_NM
     , XRPM.SEND_EMP_NO                                               -- 蹂대궦?щ엺
     , INSA1.EMP_NM                       AS SEND_EMP_NM
     , INSA1.SF_USER_ID                   AS SEND_SF_USER_ID
     , INSA1.ORG_NM
     , XRPM.EMP_NO                                                    -- 諛쏆??щ엺
     , XRPM.EMP_NM
     , INSA2.SF_USER_ID                   AS REV_SF_USER_ID
     , INSA2.ORG_NM                       AS REV_ORG_NM
     , XRPM.MONTH_RECV_ENERGY
     , XRPM.MONTH_RECV_AMT
     , CARH.REQ_EMP_ID
     , CARH.REQ_EMP_ID                    AS REQ_EMP_NO
     , (SELECT EMP_NM
          FROM HR_PSN_MST
         WHERE EMP_ID = CARH.REQ_EMP_ID)  AS REQ_EMP_NM
     , XRPM.APPR_REQ_ID                                               -- 寃곗옱?붿껌踰덊샇
     , CARH.APPR_STATUS_CD                                            -- C ?꾨즺
     , C1.APPR_STATUS_NM
     , XRPM.SLIPNO
     , XRPM.SLIP_REQ_DT
     , XRPM.SLIP_COMMENT
     , XRPM.TAXBASIC_REFLEC_YN
     , XRPM.RESIDENT_EMP_YN
     , XRPM.TAXBASIC_REQ_DT
  FROM (SELECT CALC_YYYYMM                                                      -- ?뺤궛?꾩썡
             , SEQNR                                                            -- 李⑥닔
             , SEQ_NO                                                           -- ?쒕쾲
             , TRANS_DT                                                         -- ?닿??쇱옄
             , DIV_CD
             , SEND_EMP_NO
             , EMP_NO
             , EMP_NM
             , MONTH_RECV_ENERGY
             , MONTH_RECV_AMT     
             , APPR_REQ_ID                                                      -- 寃곗옱?붿껌踰덊샇
             , SLIPNO
             , SLIP_REQ_DT
             , SLIP_COMMENT
             , (SELECT EMP_ID FROM HR_PSN_MST HPM WHERE HPM.EMP_NO = TRIM(LEADING '0' FROM XRP.EMP_NO))      AS X_EMP_ID
             , (SELECT EMP_ID FROM HR_PSN_MST HPM WHERE HPM.EMP_NO = TRIM(LEADING '0' FROM XRP.SEND_EMP_NO)) AS X_SEND_EMP_ID
             , TAXBASIC_REFLEC_YN
             , RESIDENT_EMP_YN
             , PAY_METHOD
             , DEPT_CODE
             , TAXBASIC_REQ_DT
          FROM XLGC_RWD_PEERBONUS_MST XRP
         WHERE XRP.CALC_YYYYMM = '202212' ) XRPM
  LEFT OUTER JOIN ( SELECT HPM.EMP_ID
                         , (CASE WHEN LENGTH(HPM.EMP_NO) < 8 THEN LPAD(HPM.EMP_NO, 8, '0') ELSE HPM.EMP_NO END) AS EMP_NO
                         , HPM.SF_USER_ID
                         , HPM.EMP_NM
                         , HOM.ORG_ID
                         , HAM.HR_ORG_CD
                         , HOM.ORG_NM
                      FROM HR_PSN_MST HPM
                      LEFT OUTER JOIN ( SELECT EMP_ID
                                       , EMP_NO
                                       , ORG_ID
                                       , COMP_CD
                                       , REP_COMP_CD
                                       , HR_ORG_CD
                                    FROM HR_ASG_MST
                                   WHERE DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN EFFCT_STRT_DATE AND EFFCT_END_DATE
                                     AND EMP_STAT_CD <> 'T' ) HAM
                        ON HPM.EMP_ID = HAM.EMP_ID
                      LEFT OUTER JOIN ( SELECT DISTINCT ORG_ID
                                       , HR_ORG_CD
                                       , ORG_NM
                                       , COMP_CD
                                       , REP_COMP_CD
                                    FROM HR_ORG_MST
                                   WHERE DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN EFFCT_STRT_DATE AND EFFCT_END_DATE ) HOM
                        ON HAM.COMP_CD = HOM.COMP_CD
                       AND HAM.REP_COMP_CD = HOM.REP_COMP_CD
                       AND HAM.ORG_ID = HOM.ORG_ID
                       AND HAM.HR_ORG_CD = HOM.HR_ORG_CD ) INSA1
    ON INSA1.EMP_ID = XRPM.X_SEND_EMP_ID
  LEFT OUTER JOIN ( SELECT HPM.EMP_ID
                         , (CASE WHEN LENGTH(HPM.EMP_NO) < 8 THEN LPAD(HPM.EMP_NO, 8, '0') ELSE HPM.EMP_NO END) AS EMP_NO
                         , HPM.SF_USER_ID
                         , HPM.EMP_NM
                         , HOM.ORG_ID
                         , HAM.HR_ORG_CD
                         , HOM.ORG_NM
                      FROM HR_PSN_MST HPM
                      LEFT OUTER JOIN ( SELECT EMP_ID
                                       , EMP_NO
                                       , ORG_ID
                                       , COMP_CD
                                       , REP_COMP_CD
                                       , HR_ORG_CD
                                    FROM HR_ASG_MST
                                   WHERE DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN EFFCT_STRT_DATE AND EFFCT_END_DATE
                                     AND EMP_STAT_CD <> 'T' ) HAM
                        ON HPM.EMP_ID = HAM.EMP_ID
                      LEFT OUTER JOIN ( SELECT DISTINCT ORG_ID
                                       , HR_ORG_CD
                                       , ORG_NM
                                       , COMP_CD
                                       , REP_COMP_CD
                                    FROM HR_ORG_MST
                                   WHERE DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN EFFCT_STRT_DATE AND EFFCT_END_DATE ) HOM
                        ON HAM.COMP_CD = HOM.COMP_CD
                       AND HAM.REP_COMP_CD = HOM.REP_COMP_CD
                       AND HAM.ORG_ID = HOM.ORG_ID
                       AND HAM.HR_ORG_CD = HOM.HR_ORG_CD ) INSA2
    ON INSA2.EMP_ID = XRPM.X_EMP_ID
  LEFT OUTER JOIN ( SELECT APPR_REQ_ID
                         , REQ_EMP_ID
                         , APPR_STATUS_CD
                      FROM XLGC_APPR_HDR
                     WHERE COMP_CD = IFNULL('C000', 'C000')
                       AND APPR_CATEGORY = 'EXT_XLGC_APP_001' ) CARH
    ON XRPM.APPR_REQ_ID = CARH.APPR_REQ_ID
  LEFT OUTER JOIN ( SELECT M.CD    AS APPR_STATUS_CD
                         , M.CD_NM AS APPR_STATUS_NM
                      FROM CM_CODE_GROUP G
                     INNER JOIN CM_CODE_M M
                        ON G.GRP_CD = M.GRP_CD
                     INNER JOIN CM_CODE C
                        ON M.GRP_CD = C.GRP_CD
                       AND M.CD = C.CD
                     WHERE M.GRP_CD = 'CM_APPR_STATUS'
                       AND M.LANG_CD = 'KO'
                       AND C.USE_FLAG = 'Y'
                     ORDER BY C.SORT_ODRG ASC ) C1
    ON CARH.APPR_STATUS_CD = C1.APPR_STATUS_CD
  LEFT OUTER JOIN ( SELECT M.CD    AS DIV_CD
                         , M.CD_NM AS DIV_NM
                      FROM CM_CODE_GROUP G
                     INNER JOIN CM_CODE_M M
                        ON G.GRP_CD = M.GRP_CD
                     INNER JOIN CM_CODE C
                        ON M.GRP_CD = C.GRP_CD
                       AND M.CD = C.CD
                     WHERE M.GRP_CD = 'XLGC_DIV_CD'
                       AND M.LANG_CD = 'KO'
                       AND C.USE_FLAG = 'Y'
                     ORDER BY C.SORT_ODRG ASC ) C2
    ON XRPM.DIV_CD = C2.DIV_CD
WHERE XRPM.DIV_CD = 'X000'
AND CARH.APPR_STATUS_CD = 'C'
AND XRPM.PAY_METHOD = 'C'
ORDER BY XRPM.DIV_CD, XRPM.DEPT_CODE, XRPM.SEND_EMP_NO
/* [BizActor].[DAC_XLGC_RWD_PeerBonusMgnt].[DAS_XLGC_RWD_RetrievePeerBonusSlip] */;
# Time: 2022-12-07T06:39:12.639168Z
# User@Host: erpapp[erpapp] @  [10.2.183.115]  thread_id: 6531576  server_id: 2275959756
# Query_time: 5.873137  Lock_time: 0.000988 Rows_sent: 29842  Rows_examined: 1691472
SET timestamp=1670395146;
SELECT XRPM.CALC_YYYYMM                                               -- ?뺤궛?꾩썡
     , XRPM.SEQNR                                                     -- 李⑥닔
     , XRPM.SEQ_NO                                                    -- ?쒕쾲
     , XRPM.TRANS_DT                                                  -- ?닿??쇱옄
     , XRPM.DIV_CD
     , C2.DIV_NM
     , XRPM.SEND_EMP_NO                                               -- 蹂대궦?щ엺
     , INSA1.EMP_NM                       AS SEND_EMP_NM
     , INSA1.SF_USER_ID                   AS SEND_SF_USER_ID
     , INSA1.ORG_NM
     , XRPM.EMP_NO                                                    -- 諛쏆??щ엺
     , XRPM.EMP_NM
     , INSA2.SF_USER_ID                   AS REV_SF_USER_ID
     , INSA2.ORG_NM                       AS REV_ORG_NM
     , XRPM.MONTH_RECV_ENERGY
     , XRPM.MONTH_RECV_AMT
     , CARH.REQ_EMP_ID
     , CARH.REQ_EMP_ID                    AS REQ_EMP_NO
     , (SELECT EMP_NM
          FROM HR_PSN_MST
         WHERE EMP_ID = CARH.REQ_EMP_ID)  AS REQ_EMP_NM
     , XRPM.APPR_REQ_ID                                               -- 寃곗옱?붿껌踰덊샇
     , CARH.APPR_STATUS_CD                                            -- C ?꾨즺
     , C1.APPR_STATUS_NM
     , XRPM.SLIPNO
     , XRPM.SLIP_REQ_DT
     , XRPM.SLIP_COMMENT
     , XRPM.TAXBASIC_REFLEC_YN
     , XRPM.RESIDENT_EMP_YN
     , XRPM.TAXBASIC_REQ_DT
  FROM (SELECT CALC_YYYYMM                                                      -- ?뺤궛?꾩썡
             , SEQNR                                                            -- 李⑥닔
             , SEQ_NO                                                           -- ?쒕쾲
             , TRANS_DT                                                         -- ?닿??쇱옄
             , DIV_CD
             , SEND_EMP_NO
             , EMP_NO
             , EMP_NM
             , MONTH_RECV_ENERGY
             , MONTH_RECV_AMT     
             , APPR_REQ_ID                                                      -- 寃곗옱?붿껌踰덊샇
             , SLIPNO
             , SLIP_REQ_DT
             , SLIP_COMMENT
             , (SELECT EMP_ID FROM HR_PSN_MST HPM WHERE HPM.EMP_NO = TRIM(LEADING '0' FROM XRP.EMP_NO))      AS X_EMP_ID
             , (SELECT EMP_ID FROM HR_PSN_MST HPM WHERE HPM.EMP_NO = TRIM(LEADING '0' FROM XRP.SEND_EMP_NO)) AS X_SEND_EMP_ID
             , TAXBASIC_REFLEC_YN
             , RESIDENT_EMP_YN
             , PAY_METHOD
             , DEPT_CODE
             , TAXBASIC_REQ_DT
          FROM XLGC_RWD_PEERBONUS_MST XRP
         WHERE XRP.CALC_YYYYMM = '202212' ) XRPM
  LEFT OUTER JOIN ( SELECT HPM.EMP_ID
                         , (CASE WHEN LENGTH(HPM.EMP_NO) < 8 THEN LPAD(HPM.EMP_NO, 8, '0') ELSE HPM.EMP_NO END) AS EMP_NO
                         , HPM.SF_USER_ID
                         , HPM.EMP_NM
                         , HOM.ORG_ID
                         , HAM.HR_ORG_CD
                         , HOM.ORG_NM
                      FROM HR_PSN_MST HPM
                      LEFT OUTER JOIN ( SELECT EMP_ID
                                       , EMP_NO
                                       , ORG_ID
                                       , COMP_CD
                                       , REP_COMP_CD
                                       , HR_ORG_CD
                                    FROM HR_ASG_MST
                                   WHERE DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN EFFCT_STRT_DATE AND EFFCT_END_DATE
                                     AND EMP_STAT_CD <> 'T' ) HAM
                        ON HPM.EMP_ID = HAM.EMP_ID
                      LEFT OUTER JOIN ( SELECT DISTINCT ORG_ID
                                       , HR_ORG_CD
                                       , ORG_NM
                                       , COMP_CD
                                       , REP_COMP_CD
                                    FROM HR_ORG_MST
                                   WHERE DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN EFFCT_STRT_DATE AND EFFCT_END_DATE ) HOM
                        ON HAM.COMP_CD = HOM.COMP_CD
                       AND HAM.REP_COMP_CD = HOM.REP_COMP_CD
                       AND HAM.ORG_ID = HOM.ORG_ID
                       AND HAM.HR_ORG_CD = HOM.HR_ORG_CD ) INSA1
    ON INSA1.EMP_ID = XRPM.X_SEND_EMP_ID
  LEFT OUTER JOIN ( SELECT HPM.EMP_ID
                         , (CASE WHEN LENGTH(HPM.EMP_NO) < 8 THEN LPAD(HPM.EMP_NO, 8, '0') ELSE HPM.EMP_NO END) AS EMP_NO
                         , HPM.SF_USER_ID
                         , HPM.EMP_NM
                         , HOM.ORG_ID
                         , HAM.HR_ORG_CD
                         , HOM.ORG_NM
                      FROM HR_PSN_MST HPM
                      LEFT OUTER JOIN ( SELECT EMP_ID
                                       , EMP_NO
                                       , ORG_ID
                                       , COMP_CD
                                       , REP_COMP_CD
                                       , HR_ORG_CD
                                    FROM HR_ASG_MST
                                   WHERE DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN EFFCT_STRT_DATE AND EFFCT_END_DATE
                                     AND EMP_STAT_CD <> 'T' ) HAM
                        ON HPM.EMP_ID = HAM.EMP_ID
                      LEFT OUTER JOIN ( SELECT DISTINCT ORG_ID
                                       , HR_ORG_CD
                                       , ORG_NM
                                       , COMP_CD
                                       , REP_COMP_CD
                                    FROM HR_ORG_MST
                                   WHERE DATE_FORMAT(NOW(), '%Y%m%d') BETWEEN EFFCT_STRT_DATE AND EFFCT_END_DATE ) HOM
                        ON HAM.COMP_CD = HOM.COMP_CD
                       AND HAM.REP_COMP_CD = HOM.REP_COMP_CD
                       AND HAM.ORG_ID = HOM.ORG_ID
                       AND HAM.HR_ORG_CD = HOM.HR_ORG_CD ) INSA2
    ON INSA2.EMP_ID = XRPM.X_EMP_ID
  LEFT OUTER JOIN ( SELECT APPR_REQ_ID
                         , REQ_EMP_ID
                         , APPR_STATUS_CD
                      FROM XLGC_APPR_HDR
                     WHERE COMP_CD = IFNULL('C000', 'C000')
                       AND APPR_CATEGORY = 'EXT_XLGC_APP_001' ) CARH
    ON XRPM.APPR_REQ_ID = CARH.APPR_REQ_ID
  LEFT OUTER JOIN ( SELECT M.CD    AS APPR_STATUS_CD
                         , M.CD_NM AS APPR_STATUS_NM
                      FROM CM_CODE_GROUP G
                     INNER JOIN CM_CODE_M M
                        ON G.GRP_CD = M.GRP_CD
                     INNER JOIN CM_CODE C
                        ON M.GRP_CD = C.GRP_CD
                       AND M.CD = C.CD
                     WHERE M.GRP_CD = 'CM_APPR_STATUS'
                       AND M.LANG_CD = 'KO'
                       AND C.USE_FLAG = 'Y'
                     ORDER BY C.SORT_ODRG ASC ) C1
    ON CARH.APPR_STATUS_CD = C1.APPR_STATUS_CD
  LEFT OUTER JOIN ( SELECT M.CD    AS DIV_CD
                         , M.CD_NM AS DIV_NM
                      FROM CM_CODE_GROUP G
                     INNER JOIN CM_CODE_M M
                        ON G.GRP_CD = M.GRP_CD
                     INNER JOIN CM_CODE C
                        ON M.GRP_CD = C.GRP_CD
                       AND M.CD = C.CD
                     WHERE M.GRP_CD = 'XLGC_DIV_CD'
                       AND M.LANG_CD = 'KO'
                       AND C.USE_FLAG = 'Y'
                     ORDER BY C.SORT_ODRG ASC ) C2
    ON XRPM.DIV_CD = C2.DIV_CD
WHERE XRPM.DIV_CD = 'X000'
AND IFNULL(XRPM.RESIDENT_EMP_YN, 'N') = 'N'
AND CARH.APPR_STATUS_CD = 'C'
AND XRPM.PAY_METHOD = 'C'
ORDER BY XRPM.DIV_CD, XRPM.DEPT_CODE, XRPM.SEND_EMP_NO
/* [BizActor].[DAC_XLGC_RWD_PeerBonusMgnt].[DAS_XLGC_RWD_RetrievePeerBonusSlip] */;
