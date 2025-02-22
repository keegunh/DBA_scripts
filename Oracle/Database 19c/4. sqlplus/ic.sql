/*
Interconnect 사용량 확인
	- NAME
		-- cache	: Global Cache 통신
		-- ipq		: 병렬 쿼리 데이터 통신
		-- dlm		: Database Lock 관리
	- MB_SENT		: 해당 NAME에 대해 Instance 기동 이후 Instance에서 보낸 MB 수
	- MB_RECEIVED	: 해당 NAME에 대해 Instance 기동 이후 Instance에서 받은 MB 수
	- MB_TOTAL		: 해당 NAME에 대해 Instance 기동 이후 Instance에서 보낸 MB 수와 받은 MB수의 합
	- PREC_TOTAL	: 해당 NAME에 대해 Instance 기동 이후 Instance에서 보낸 비율
*/

TTITLE "[DBname] Database| Interconnect Usage"

SET LINESIZE 200
SET PAGESIZE 1000
SET HEADING ON

SELECT SNAP_ID
     , INSTANCE_NUMBER
	 , NAME
	 , TRUNC(BYTES_SENT/1024/1024) AS MB_SENT
	 , TRUNC(BYTES_RECEIVED/1024/1024) AS MB_RCV
	 , TRUNC((BYTES_SENT+BYTES_RECEIVED)/1024/1024) AS MB_TOTAL
	 , TO_CHAR(ROUND(100*((BYTES_SENT+BYTES_RECEIVED)/1024/1024)/SUM((BYTES_SENT+BYTES_RECEIVED)/1024/1024) OVER(), 2), '990.00') AS PREC_TOTAL
  FROM DBA_HIST_IC_CLIENT_STATS
 WHERE 1=1
   AND INSTANCE_NUMBER = 1
   AND SNAP_ID = (SELECT MAX(SNAP_ID) FROM DBA_HIST_IC_CLIENT_STATS)
 ORDER BY INSTANCE_NUMBER, NAME
;