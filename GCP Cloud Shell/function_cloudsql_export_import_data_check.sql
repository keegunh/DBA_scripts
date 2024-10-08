################### LOG DB ######################
show schemas;

-- CM_USER_LOGIN
-- PRD_PORTAL
SELECT SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
     , COUNT(CNT) DAY_COUNT
	 , SUM(CNT) AS DATA_COUNT
	 , MAX(AUTO_INC_SEQ_ID) AS MAX_AUTO_INC_SEQ_ID
	 , MAX(CRT_DT) AS MAX_CRT_DT
  FROM (SELECT SUBSTR(CRT_DT, 1, 8) AS YYYYMMDD
             , COUNT(1) AS CNT
			 , MAX(AUTO_INC_SEQ_ID) AS AUTO_INC_SEQ_ID
			 , MAX(CRT_DT) AS CRT_DT
          FROM PRD_PORTAL.CM_USER_LOGIN
         -- WHERE CRT_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
         GROUP BY SUBSTR(CRT_DT, 1, 8)) X
 GROUP BY SUBSTR(YYYYMMDD, 1, 6);
SELECT SUBSTR(CRT_DT, 1, 8)
     , COUNT(1)
	 , MAX(AUTO_INC_SEQ_ID)
	 , MAX(CRT_DT)
  FROM PRD_PORTAL.CM_USER_LOGIN
 -- WHERE CRT_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
 GROUP BY SUBSTR(CRT_DT, 1, 8);

-- PRD_LGCNS
SELECT SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
     , COUNT(CNT) DAY_COUNT
	 , SUM(CNT) AS DATA_COUNT
	 , MAX(AUTO_INC_SEQ_ID) AS MAX_AUTO_INC_SEQ_ID
	 , MAX(CRT_DT) AS MAX_CRT_DT
  FROM (SELECT SUBSTR(CRT_DT, 1, 8) AS YYYYMMDD
             , COUNT(1) AS CNT
			 , MAX(AUTO_INC_SEQ_ID) AS AUTO_INC_SEQ_ID
			 , MAX(CRT_DT) AS CRT_DT
          FROM PRD_LGCNS.CM_USER_LOGIN
         -- WHERE CRT_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
         GROUP BY SUBSTR(CRT_DT, 1, 8)) X
 GROUP BY SUBSTR(YYYYMMDD, 1, 6);
SELECT SUBSTR(CRT_DT, 1, 8)
     , COUNT(1)
	 , MAX(AUTO_INC_SEQ_ID)
	 , MAX(CRT_DT)
  FROM PRD_LGCNS.CM_USER_LOGIN
 -- WHERE CRT_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
 GROUP BY SUBSTR(CRT_DT, 1, 8);
 
-- PRD_LGC 
SELECT SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
     , COUNT(CNT) DAY_COUNT
	 , SUM(CNT) AS DATA_COUNT
	 , MAX(AUTO_INC_SEQ_ID) AS MAX_AUTO_INC_SEQ_ID
	 , MAX(CRT_DT) AS MAX_CRT_DT
  FROM (SELECT SUBSTR(CRT_DT, 1, 8) AS YYYYMMDD
             , COUNT(1) AS CNT
			 , MAX(AUTO_INC_SEQ_ID) AS AUTO_INC_SEQ_ID
			 , MAX(CRT_DT) AS CRT_DT
          FROM PRD_LGC.CM_USER_LOGIN
         -- WHERE CRT_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
         GROUP BY SUBSTR(CRT_DT, 1, 8)) X
 GROUP BY SUBSTR(YYYYMMDD, 1, 6);
SELECT SUBSTR(CRT_DT, 1, 8)
     , COUNT(1)
	 , MAX(AUTO_INC_SEQ_ID)
	 , MAX(CRT_DT)
  FROM PRD_LGC.CM_USER_LOGIN
 -- WHERE CRT_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
 GROUP BY SUBSTR(CRT_DT, 1, 8);
 
-- PRD_LGES
SELECT SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
     , COUNT(CNT) DAY_COUNT
	 , SUM(CNT) AS DATA_COUNT
	 , MAX(AUTO_INC_SEQ_ID) AS MAX_AUTO_INC_SEQ_ID
	 , MAX(CRT_DT) AS MAX_CRT_DT
  FROM (SELECT SUBSTR(CRT_DT, 1, 8) AS YYYYMMDD
             , COUNT(1) AS CNT
			 , MAX(AUTO_INC_SEQ_ID) AS AUTO_INC_SEQ_ID
			 , MAX(CRT_DT) AS CRT_DT
          FROM PRD_LGES.CM_USER_LOGIN
         -- WHERE CRT_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
         GROUP BY SUBSTR(CRT_DT, 1, 8)) X
 GROUP BY SUBSTR(YYYYMMDD, 1, 6);
SELECT SUBSTR(CRT_DT, 1, 8)
     , COUNT(1)
	 , MAX(AUTO_INC_SEQ_ID)
	 , MAX(CRT_DT)
  FROM PRD_LGES.CM_USER_LOGIN
 -- WHERE CRT_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
 GROUP BY SUBSTR(CRT_DT, 1, 8);

################### PORTAL, LGCNS, LGC, LGES ######################
-- ERPAPP 
SELECT SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
     , COUNT(CNT) DAY_COUNT
	 , SUM(CNT) AS DATA_COUNT
	 , MAX(AUTO_INC_SEQ_ID) AS MAX_AUTO_INC_SEQ_ID
	 , MAX(CRT_DT) AS MAX_CRT_DT
  FROM (SELECT SUBSTR(CRT_DT, 1, 8) AS YYYYMMDD
             , COUNT(1) AS CNT
			 , MAX(AUTO_INC_SEQ_ID) AS AUTO_INC_SEQ_ID
			 , MAX(CRT_DT) AS CRT_DT
          FROM ERPAPP.CM_USER_LOGIN
         -- WHERE CRT_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
         GROUP BY SUBSTR(CRT_DT, 1, 8)) X
 GROUP BY SUBSTR(YYYYMMDD, 1, 6);
SELECT SUBSTR(CRT_DT, 1, 8)
     , COUNT(1)
	 , MAX(AUTO_INC_SEQ_ID)
	 , MAX(CRT_DT)
  FROM ERPAPP.CM_USER_LOGIN
 -- WHERE CRT_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
 GROUP BY SUBSTR(CRT_DT, 1, 8);

##########################################################################################################################################

################### LOG DB ######################
-- CM_HEALTH_CHK_LOG
-- PRD_PORTAL
SELECT SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
     , COUNT(CNT) DAY_COUNT
	 , SUM(CNT) AS DATA_COUNT
	 , MAX(AUTO_INC_SEQ_ID) AS MAX_AUTO_INC_SEQ_ID
	 , MAX(EXEC_START_DT) AS MAX_EXEC_START_DT
  FROM (SELECT SUBSTR(EXEC_START_DT, 1, 8) AS YYYYMMDD
             , COUNT(1) AS CNT
			 , MAX(AUTO_INC_SEQ_ID) AS AUTO_INC_SEQ_ID
			 , MAX(EXEC_START_DT) AS EXEC_START_DT
          FROM PRD_PORTAL.CM_HEALTH_CHK_LOG
         -- WHERE EXEC_START_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
         GROUP BY SUBSTR(EXEC_START_DT, 1, 8)) X
 GROUP BY SUBSTR(YYYYMMDD, 1, 6);
SELECT SUBSTR(EXEC_START_DT, 1, 8)
     , COUNT(1)
	 , MAX(AUTO_INC_SEQ_ID)
	 , MAX(EXEC_START_DT)
  FROM PRD_PORTAL.CM_HEALTH_CHK_LOG
 -- WHERE EXEC_START_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
 GROUP BY SUBSTR(EXEC_START_DT, 1, 8);

-- PRD_LGCNS
SELECT SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
     , COUNT(CNT) DAY_COUNT
	 , SUM(CNT) AS DATA_COUNT
	 , MAX(AUTO_INC_SEQ_ID) AS MAX_AUTO_INC_SEQ_ID
	 , MAX(EXEC_START_DT) AS MAX_EXEC_START_DT
  FROM (SELECT SUBSTR(EXEC_START_DT, 1, 8) AS YYYYMMDD
             , COUNT(1) AS CNT
			 , MAX(AUTO_INC_SEQ_ID) AS AUTO_INC_SEQ_ID
			 , MAX(EXEC_START_DT) AS EXEC_START_DT
          FROM PRD_LGCNS.CM_HEALTH_CHK_LOG
         -- WHERE EXEC_START_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
         GROUP BY SUBSTR(EXEC_START_DT, 1, 8)) X
 GROUP BY SUBSTR(YYYYMMDD, 1, 6);
SELECT SUBSTR(EXEC_START_DT, 1, 8)
     , COUNT(1)
	 , MAX(AUTO_INC_SEQ_ID)
	 , MAX(EXEC_START_DT)
  FROM PRD_LGCNS.CM_HEALTH_CHK_LOG
 -- WHERE EXEC_START_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
 GROUP BY SUBSTR(EXEC_START_DT, 1, 8);
 
-- PRD_LGC 
SELECT SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
     , COUNT(CNT) DAY_COUNT
	 , SUM(CNT) AS DATA_COUNT
	 , MAX(AUTO_INC_SEQ_ID) AS MAX_AUTO_INC_SEQ_ID
	 , MAX(EXEC_START_DT) AS MAX_EXEC_START_DT
  FROM (SELECT SUBSTR(EXEC_START_DT, 1, 8) AS YYYYMMDD
             , COUNT(1) AS CNT
			 , MAX(AUTO_INC_SEQ_ID) AS AUTO_INC_SEQ_ID
			 , MAX(EXEC_START_DT) AS EXEC_START_DT
          FROM PRD_LGC.CM_HEALTH_CHK_LOG
         -- WHERE EXEC_START_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
         GROUP BY SUBSTR(EXEC_START_DT, 1, 8)) X
 GROUP BY SUBSTR(YYYYMMDD, 1, 6);
SELECT SUBSTR(EXEC_START_DT, 1, 8)
     , COUNT(1)
	 , MAX(AUTO_INC_SEQ_ID)
	 , MAX(EXEC_START_DT)
  FROM PRD_LGC.CM_HEALTH_CHK_LOG
 -- WHERE EXEC_START_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
 GROUP BY SUBSTR(EXEC_START_DT, 1, 8);
 
-- PRD_LGES
SELECT SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
     , COUNT(CNT) DAY_COUNT
	 , SUM(CNT) AS DATA_COUNT
	 , MAX(AUTO_INC_SEQ_ID) AS MAX_AUTO_INC_SEQ_ID
	 , MAX(EXEC_START_DT) AS MAX_EXEC_START_DT
  FROM (SELECT SUBSTR(EXEC_START_DT, 1, 8) AS YYYYMMDD
             , COUNT(1) AS CNT
			 , MAX(AUTO_INC_SEQ_ID) AS AUTO_INC_SEQ_ID
			 , MAX(EXEC_START_DT) AS EXEC_START_DT
          FROM PRD_LGES.CM_HEALTH_CHK_LOG
         -- WHERE EXEC_START_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
         GROUP BY SUBSTR(EXEC_START_DT, 1, 8)) X
 GROUP BY SUBSTR(YYYYMMDD, 1, 6);
SELECT SUBSTR(EXEC_START_DT, 1, 8)
     , COUNT(1)
	 , MAX(AUTO_INC_SEQ_ID)
	 , MAX(EXEC_START_DT)
  FROM PRD_LGES.CM_HEALTH_CHK_LOG
 -- WHERE EXEC_START_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
 GROUP BY SUBSTR(EXEC_START_DT, 1, 8);

################### PORTAL, LGCNS, LGC, LGES ######################
-- ERPAPP
SELECT SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM
     , COUNT(CNT) DAY_COUNT
	 , SUM(CNT) AS DATA_COUNT
	 , MAX(AUTO_INC_SEQ_ID) AS MAX_AUTO_INC_SEQ_ID
	 , MAX(EXEC_START_DT) AS MAX_EXEC_START_DT
  FROM (SELECT SUBSTR(EXEC_START_DT, 1, 8) AS YYYYMMDD
             , COUNT(1) AS CNT
			 , MAX(AUTO_INC_SEQ_ID) AS AUTO_INC_SEQ_ID
			 , MAX(EXEC_START_DT) AS EXEC_START_DT
          FROM ERPAPP.CM_HEALTH_CHK_LOG
         -- WHERE EXEC_START_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
         GROUP BY SUBSTR(EXEC_START_DT, 1, 8)) X
 GROUP BY SUBSTR(YYYYMMDD, 1, 6);
SELECT SUBSTR(EXEC_START_DT, 1, 8)
     , COUNT(1)
	 , MAX(AUTO_INC_SEQ_ID)
	 , MAX(EXEC_START_DT)
  FROM ERPAPP.CM_HEALTH_CHK_LOG
 -- WHERE EXEC_START_DT BETWEEN '20220925000000' AND DATE_FORMAT(DATE_ADD(DATE_FORMAT(NOW(), '%Y%m%d%H%I%S'), INTERVAL -1 DAY), '%Y%M%D')
 GROUP BY SUBSTR(EXEC_START_DT, 1, 8);