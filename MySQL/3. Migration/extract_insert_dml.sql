SELECT CONCAT('INSERT INTO CM_USER_LOGIN VALUES ('
     , AUTO_INC_SEQ_ID, ', '
     , USER_ID
     , IF(CLIENT_IP IS NULL, ', ', ', '''), IFNULL(CLIENT_IP, 'NULL'), IF(CLIENT_IP IS NULL, '', '''')
     , IF(BROWSER_TYPE IS NULL, ', ', ', '''), IFNULL(BROWSER_TYPE, 'NULL'), IF(BROWSER_TYPE IS NULL, '', '''')
     , IF(LOGIN_TYPE IS NULL, ', ', ', '''), IFNULL(LOGIN_TYPE, 'NULL'), IF(LOGIN_TYPE IS NULL, ', ''', ''', ''')
     , LOGIN_DT, ''', '
     , CRT_ID, ', '''
     , CRT_DT, ''', '
     , UPDT_ID, ', '''
     , UPDT_DT, ''');') AS INSERT_DML
  FROM ERPAPP.CM_USER_LOGIN;

SELECT CONCAT('INSERT INTO CM_HEALTH_CHK_LOG VALUES (',
       AUTO_INC_SEQ_ID, ', '
     , '''', SERVICE_ID, ''''
     , IF(MENU_URL IS NULL, ', ', ', '''), IFNULL(MENU_URL, 'NULL'), IF(MENU_URL IS NULL, '', '''')
     , IF(MENU_CD IS NULL, ', ', ', '''), IFNULL(MENU_CD, 'NULL'), IF(MENU_CD IS NULL, '', '''')	 
     , IF(ARGUMENT_TEXT IS NULL, ', ', ', '''), REPLACE(IFNULL(ARGUMENT_TEXT, 'NULL'), '''', ''''''), IF(ARGUMENT_TEXT IS NULL, '', '''')
     , IF(EXEC_START_DT IS NULL, ', ', ', '''), IFNULL(EXEC_START_DT, 'NULL'), IF(EXEC_START_DT IS NULL, '', '''')
     , IF(EXEC_END_DT IS NULL, ', ', ', '''), IFNULL(EXEC_END_DT, 'NULL'), IF(EXEC_END_DT IS NULL, '', '''')
     , ', ', IFNULL(TIME_GAP, 'NULL') 
     , IF(RESULT_STATUS IS NULL, ', ', ', '''), IFNULL(RESULT_STATUS, 'NULL'), IF(RESULT_STATUS IS NULL, '', '''')
     , IF(RESULT_MESSAGE IS NULL, ', ', ', '''), REPLACE(IFNULL(RESULT_MESSAGE, 'NULL'), '''', ''''''), IF(RESULT_MESSAGE IS NULL, '', '''')
     , ', ', CRT_ID, ', '
     , '''', CRT_DT, ''''
     , ', ', UPDT_ID, ', '
     , '''', UPDT_DT, ''''
     , IF(ATTR1 IS NULL, ', ', ', '''), IFNULL(ATTR1, 'NULL'), IF(ATTR1 IS NULL, '', '''')
     , IF(ATTR2 IS NULL, ', ', ', '''), IFNULL(ATTR2, 'NULL'), IF(ATTR2 IS NULL, '', '''')
     , IF(ATTR3 IS NULL, ', ', ', '''), IFNULL(ATTR3, 'NULL'), IF(ATTR3 IS NULL, '', '''')
     , IF(ATTR4 IS NULL, ', ', ', '''), IFNULL(ATTR4, 'NULL'), IF(ATTR4 IS NULL, '', '''')
     , IF(ATTR5 IS NULL, ', ', ', '''), IFNULL(ATTR5, 'NULL'), IF(ATTR5 IS NULL, '', '''')
     , IF(ATTR6 IS NULL, ', ', ', '''), IFNULL(ATTR6, 'NULL'), IF(ATTR6 IS NULL, '', '''')
     , IF(ATTR7 IS NULL, ', ', ', '''), IFNULL(ATTR7, 'NULL'), IF(ATTR7 IS NULL, '', '''')
     , IF(ATTR8 IS NULL, ', ', ', '''), IFNULL(ATTR8, 'NULL'), IF(ATTR8 IS NULL, '', '''')
     , IF(ATTR9 IS NULL, ', ', ', '''), IFNULL(ATTR9, 'NULL'), IF(ATTR9 IS NULL, '', '''')
     , IF(ATTR10 IS NULL, ', ', ', '''), IFNULL(ATTR10, 'NULL'), IF(ATTR10 IS NULL, '', '''')
     , IF(ATTR11 IS NULL, ', ', ', '''), IFNULL(ATTR11, 'NULL'), IF(ATTR11 IS NULL, '', '''')
     , IF(ATTR12 IS NULL, ', ', ', '''), IFNULL(ATTR12, 'NULL'), IF(ATTR12 IS NULL, '', '''')
     , IF(ATTR13 IS NULL, ', ', ', '''), IFNULL(ATTR13, 'NULL'), IF(ATTR13 IS NULL, '', '''')
     , IF(ATTR14 IS NULL, ', ', ', '''), IFNULL(ATTR14, 'NULL'), IF(ATTR14 IS NULL, '', '''')
     , IF(ATTR15 IS NULL, ', ', ', '''), IFNULL(ATTR15, 'NULL'), IF(ATTR15 IS NULL, '', '''')
     , IF(CLIENT_IP IS NULL, ', ', ', '''), IFNULL(CLIENT_IP, 'NULL'), IF(CLIENT_IP IS NULL, '', '''')
     , ');') AS INSERT_DML
  FROM ERPAPP.CM_HEALTH_CHK_LOG;