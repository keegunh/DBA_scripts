################### LOG DB ######################
show schemas;

-- STG PORTAL (그제까지의 데이터)
select count(1), max(AUTO_INC_SEQ_ID), max(EXEC_START_DT) -- 202891
  from STG_PORTAL.CM_HEALTH_CHK_LOG WHERE EXEC_START_DT < date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
select count(1), max(AUTO_INC_SEQ_ID), max(CRT_DT) -- 15042
  from STG_PORTAL.CM_USER_LOGIN WHERE CRT_DT < date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');

-- STG PORTAL (어제 + 오늘 데이터)
select count(1), max(AUTO_INC_SEQ_ID), max(EXEC_START_DT) -- 0
  from STG_PORTAL.CM_HEALTH_CHK_LOG WHERE EXEC_START_DT >= date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
select count(1), max(AUTO_INC_SEQ_ID), max(CRT_DT) -- 0
  from STG_PORTAL.CM_USER_LOGIN WHERE CRT_DT >= date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');

  
  
-- STG LGCNS (그제까지의 데이터)
select count(1), max(AUTO_INC_SEQ_ID), max(EXEC_START_DT) -- 1141127
  from STG_LGCNS.CM_HEALTH_CHK_LOG WHERE EXEC_START_DT < date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
select count(1), max(AUTO_INC_SEQ_ID), max(CRT_DT) -- 27154
  from STG_LGCNS.CM_USER_LOGIN WHERE CRT_DT < date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');

-- STG LGCNS (어제 + 오늘 데이터)
select count(1), max(AUTO_INC_SEQ_ID), max(EXEC_START_DT) -- 0
  from STG_LGCNS.CM_HEALTH_CHK_LOG WHERE EXEC_START_DT >= date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
select count(1), max(AUTO_INC_SEQ_ID), max(CRT_DT) -- 0
  from STG_LGCNS.CM_USER_LOGIN WHERE CRT_DT >= date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');

  
  
-- STG LGC (그제까지의 데이터)
select count(1), max(AUTO_INC_SEQ_ID), max(EXEC_START_DT) -- 770900
  from STG_LGC.CM_HEALTH_CHK_LOG WHERE EXEC_START_DT < date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
select count(1), max(AUTO_INC_SEQ_ID), max(CRT_DT) -- 21634
  from STG_LGC.CM_USER_LOGIN WHERE CRT_DT < date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');

-- STG LGC (어제 + 오늘 데이터)
select count(1), max(AUTO_INC_SEQ_ID), max(EXEC_START_DT) -- 0
  from STG_LGC.CM_HEALTH_CHK_LOG WHERE EXEC_START_DT >= date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
select count(1), max(AUTO_INC_SEQ_ID), max(CRT_DT) -- 0
  from STG_LGC.CM_USER_LOGIN WHERE CRT_DT >= date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
  
  
  
-- STG LGES (그제까지의 데이터)
select count(1), max(AUTO_INC_SEQ_ID), max(EXEC_START_DT) -- 562518
  from STG_LGES.CM_HEALTH_CHK_LOG WHERE EXEC_START_DT < date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
select count(1), max(AUTO_INC_SEQ_ID), max(CRT_DT) -- 16444
  from STG_LGES.CM_USER_LOGIN WHERE CRT_DT < date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');

-- STG LGES (어제 + 오늘 데이터)
select count(1), max(AUTO_INC_SEQ_ID), max(EXEC_START_DT) -- 0
  from STG_LGES.CM_HEALTH_CHK_LOG WHERE EXEC_START_DT >= date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
select count(1), max(AUTO_INC_SEQ_ID), max(CRT_DT) -- 0
  from STG_LGES.CM_USER_LOGIN WHERE CRT_DT >= date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');











################### PORTAL, LGCNS, LGC, LGES DB ######################
-- (그제까지의 데이터)
select count(1), max(AUTO_INC_SEQ_ID), max(EXEC_START_DT)
  from ERPAPP.CM_HEALTH_CHK_LOG WHERE EXEC_START_DT < date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
select count(1), max(AUTO_INC_SEQ_ID), max(CRT_DT)
  from ERPAPP.CM_USER_LOGIN WHERE CRT_DT < date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');

-- (어제 + 오늘 데이터)
select count(1), max(AUTO_INC_SEQ_ID), max(EXEC_START_DT)
  from ERPAPP.CM_HEALTH_CHK_LOG WHERE EXEC_START_DT >= date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');
select count(1), max(AUTO_INC_SEQ_ID), max(CRT_DT)
  from ERPAPP.CM_USER_LOGIN WHERE CRT_DT >= date_format(date_add(date_format(now(), '%Y-%m-%d %H:%i:%s'), interval -1 day), '%Y%m%d');

/*  
SOURCE DB DATA
STG PORTAL
	그제까지의 데이터 :
		- ERPAPP.CM_HEALTH_CHK_LOG : 202891
		- ERPAPP.CM_USER_LOGIN : 15042
	어제 + 오늘 데이터 :
		- ERPAPP.CM_HEALTH_CHK_LOG : 0 
		- ERPAPP.CM_USER_LOGIN : 17

STG LGCNS
	그제까지의 데이터 :
		- ERPAPP.CM_HEALTH_CHK_LOG : 1141142
		- ERPAPP.CM_USER_LOGIN : 27154
	어제 + 오늘 데이터 :
		- ERPAPP.CM_HEALTH_CHK_LOG : 2000
		- ERPAPP.CM_USER_LOGIN : 34
		
STG LGC
	그제까지의 데이터 :
		- ERPAPP.CM_HEALTH_CHK_LOG : 771981
		- ERPAPP.CM_USER_LOGIN : 21634
	어제 + 오늘 데이터 :
		- ERPAPP.CM_HEALTH_CHK_LOG : 2121
		- ERPAPP.CM_USER_LOGIN : 49
		
STG LGES
	그제까지의 데이터 :
		- ERPAPP.CM_HEALTH_CHK_LOG : 562518
		- ERPAPP.CM_USER_LOGIN : 16444
	어제 + 오늘 데이터 :
		- ERPAPP.CM_HEALTH_CHK_LOG : 2222
		- ERPAPP.CM_USER_LOGIN : 34
*/