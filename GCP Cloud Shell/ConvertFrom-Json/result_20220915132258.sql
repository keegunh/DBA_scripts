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
AND XRPM.EMP_NO BETWEEN '00212992' AND '00212992' 
AND CARH.APPR_STATUS_CD = 'C'
AND XRPM.PAY_METHOD = 'C'
ORDER BY XRPM.DIV_CD, XRPM.DEPT_CODE, XRPM.SEND_EMP_NO
/* [BizActor].[DAC_XLGC_RWD_PeerBonusMgnt].[DAS_XLGC_RWD_RetrievePeerBonusSlip] */;
# Time: 2022-09-14T23:41:02.753087Z
# User@Host: erpapp[erpapp] @  [10.2.183.110]  thread_id: 4220508  server_id: 4282968835
# Query_time: 69.447222  Lock_time: 0.000752 Rows_sent: 1  Rows_examined: 298097934
SET timestamp=1663198793;
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
             , (SELECT EMP_ID FROM HR_PSN_MST HPM WHERE LPAD(HPM.EMP_NO, 8, '0') = XRP.EMP_NO)      AS X_EMP_ID
             , (SELECT EMP_ID FROM HR_PSN_MST HPM WHERE LPAD(HPM.EMP_NO, 8, '0') = XRP.SEND_EMP_NO) AS X_SEND_EMP_ID
             , TAXBASIC_REFLEC_YN
             , RESIDENT_EMP_YN
             , PAY_METHOD
             , DEPT_CODE
          FROM XLGC_RWD_PEERBONUS_MST XRP
         WHERE XRP.CALC_YYYYMM = '202208' ) XRPM
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
                      LEFT OUTER JOIN ( SELECT ORG_ID
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
                      LEFT OUTER JOIN ( SELECT ORG_ID
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
AND XRPM.EMP_NO BETWEEN '00212992' AND '00212992' 
AND CARH.APPR_STATUS_CD = 'C'
AND XRPM.PAY_METHOD = 'C'
ORDER BY XRPM.DIV_CD, XRPM.DEPT_CODE, XRPM.SEND_EMP_NO
/* [BizActor].[DAC_XLGC_RWD_PeerBonusMgnt].[DAS_XLGC_RWD_RetrievePeerBonusSlip] */;
/usr/sbin/mysqld, Version: 8.0.18-google ((Google)). started with:
Tcp port: 3306  Unix socket: /mysql/mysql.sock
Time           user_host      thread_id      server_id       Command    Argument
# Time: 2022-09-14T23:44:04.481989Z
# User@Host: erpapp[erpapp] @  [10.2.183.116]  thread_id: 4220633  server_id: 4282968835
# Query_time: 69.950580  Lock_time: 0.000683 Rows_sent: 1  Rows_examined: 298097934
SET timestamp=1663198974;
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
             , (SELECT EMP_ID FROM HR_PSN_MST HPM WHERE LPAD(HPM.EMP_NO, 8, '0') = XRP.EMP_NO)      AS X_EMP_ID
             , (SELECT EMP_ID FROM HR_PSN_MST HPM WHERE LPAD(HPM.EMP_NO, 8, '0') = XRP.SEND_EMP_NO) AS X_SEND_EMP_ID
             , TAXBASIC_REFLEC_YN
             , RESIDENT_EMP_YN
             , PAY_METHOD
             , DEPT_CODE
          FROM XLGC_RWD_PEERBONUS_MST XRP
         WHERE XRP.CALC_YYYYMM = '202208' ) XRPM
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
                      LEFT OUTER JOIN ( SELECT ORG_ID
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
                      LEFT OUTER JOIN ( SELECT ORG_ID
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
AND XRPM.EMP_NO BETWEEN '00212992' AND '00212992' 
AND CARH.APPR_STATUS_CD = 'C'
AND XRPM.PAY_METHOD = 'C'
ORDER BY XRPM.DIV_CD, XRPM.DEPT_CODE, XRPM.SEND_EMP_NO
/* [BizActor].[DAC_XLGC_RWD_PeerBonusMgnt].[DAS_XLGC_RWD_RetrievePeerBonusSlip] */;
# Time: 2022-09-15T00:17:16.930974Z
# User@Host: erpapp[erpapp] @  [10.2.183.113]  thread_id: 4220672  server_id: 4282968835
# Query_time: 69.325434  Lock_time: 0.000816 Rows_sent: 1  Rows_examined: 298097934
use ERPAPP;
SET timestamp=1663200967;
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
             , (SELECT EMP_ID FROM HR_PSN_MST HPM WHERE LPAD(HPM.EMP_NO, 8, '0') = XRP.EMP_NO)      AS X_EMP_ID
             , (SELECT EMP_ID FROM HR_PSN_MST HPM WHERE LPAD(HPM.EMP_NO, 8, '0') = XRP.SEND_EMP_NO) AS X_SEND_EMP_ID
             , TAXBASIC_REFLEC_YN
             , RESIDENT_EMP_YN
             , PAY_METHOD
             , DEPT_CODE
          FROM XLGC_RWD_PEERBONUS_MST XRP
         WHERE XRP.CALC_YYYYMM = '202208' ) XRPM
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
                      LEFT OUTER JOIN ( SELECT ORG_ID
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
                      LEFT OUTER JOIN ( SELECT ORG_ID
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
AND XRPM.EMP_NO BETWEEN '00212992' AND '00212992' 
AND CARH.APPR_STATUS_CD = 'C'
AND XRPM.PAY_METHOD = 'C'
ORDER BY XRPM.DIV_CD, XRPM.DEPT_CODE, XRPM.SEND_EMP_NO
/* [BizActor].[DAC_XLGC_RWD_PeerBonusMgnt].[DAS_XLGC_RWD_RetrievePeerBonusSlip] */;
# Time: 2022-09-15T00:53:44.183241Z
# User@Host: erpview[erpview] @  [10.1.121.193]  thread_id: 4263931  server_id: 4282968835
# Query_time: 3.456252  Lock_time: 0.000341 Rows_sent: 97567  Rows_examined: 97567
SET timestamp=1663203220;
SELECT * FROM HR_COMP_NONRECCURING_HIST;
# Time: 2022-09-15T00:57:43.159772Z
# User@Host: erpview[erpview] @  [10.1.121.193]  thread_id: 4264027  server_id: 4282968835
# Query_time: 3.582188  Lock_time: 0.000047 Rows_sent: 97567  Rows_examined: 97567
SET timestamp=1663203459;
SELECT *
FROM   HR_COMP_NONRECCURING_HIST;
