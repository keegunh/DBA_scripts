## SOURCE : DBLINK로 쿼리를 날리는 서버
## DESTINATION : DBLINK 목적지로 쿼리가 수행될 서버

### DESTINATION 환경 ifconfig -a 확인 -> 본 예시에서는 7.7.7.3 IP가 망내 DB통신용 IP로 확인됨

### 1-1. DESTINATION 환경 리스너 추가 - listener.ora에 아래 신규 정보 추가
### 포트번호는 기존에 사용하는 포트와 겹치면 안 됨.
LIS_DBLINK_SRCDB = 
  (ADDRESS = (PROTOCOL = TCP) (HOST = 7.7.7.3) (PORT = 1522))
  
### 1-2. DESTINATION 환경 리스너 추가 - tnsnames.ora에 아래 신규 정보 추가
DBLINK_SRCDB =
  (DESCRIPTION = 
    (ADDRESS = (PROTOCOL = TCP) (HOST = 7.7.7.3) (PORT = 1522))
	(CONNECT_DATA = 
	  (SERVER = DEDICATED)
	  (SERVICE_NAME = SRCDB)
	)
  )
LIS_DBLINK_SRCDB =
  (DESCRIPTION_LIST =
    (DESCRIPTION =
	  (ADDRESS = (PROTOCOL = TCP) (HOST = 7.7.7.3) (PORT = 1522))
	)
  )

### 1-3. DESTINATION 환경 리스너 추가 - local_listener 파라미터에 신규 리스너 등록
ALTER SYSTEM SET LOCAL_LISTENER = 'LIS_SRCDB','LIS_DBLINK_SRCDB';	-- '기존 리스너','추가한 리스너'

### 2. DESTINATION 환경 신규 리스너 기동
lsnrctl start LIS_DBLINK_SRCDB
lsnrctl status LIS_DBLINK_SRCDB

### 3. SOURCE 환경 tnsnames.ora 변경
SRCDB =
  (DESCRIPTION = 
    (ADDRESS = (PROTOCOL = TCP) (HOST = 7.7.7.3) (PORT = 1522))
	(CONNECT_DATA = 
	  (SERVER = DEDICATED)
	  (SERVICE_NAME = SRCDB)
	)
  )

-----------------------------------------------------------------------------------------------------
### 4. SOURCE 환경 DBLINK 생성 및 테스트
CREATE [PUBLIC] DATABASE LINK SRCDB CONNECT TO DEST_DB_USER IDENTIFIED BY "PASSWORD" USING 'SRCDB';
SELECT 1 FROM DUAL@SRCDB;
SELECT INSTANCE_NAME FROM V$INSTANCE@SRCDB;