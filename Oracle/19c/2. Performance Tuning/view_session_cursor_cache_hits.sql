SELECT A.VALUE "SESSION CURSOR CACHE HITS"
     , B.VALUE "TOTAL PARSE CALL COUNT"
	 , ROUND(A.VALUE/B.VALUE*100,2) "SESSION CURSOR CACHE HITS%"
  FROM V$SYSSTAT A
     , V$SYSSTAT B
 WHERE A.NAME = 'session cursor cache hits'
   AND B.NAME = 'parse count (total)'

-- ALTER SESSION SET session_cached_cursors = 0;