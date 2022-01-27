WITH T AS (
   SELECT 1 A ,NULL B FROM DUAL
   UNION ALL
   SELECT 2,1 FROM DUAL
   UNION ALL
   SELECT NULL,2 FROM DUAL
   UNION ALL
   SELECT NULL,NULL FROM DUAL
)
--SELECT AVG(A),COUNT(A),AVG(B),COUNT(B) FROM T;
SELECT B FROM T GROUP BY B HAVING COUNT(*) > 1;


/*
GROUP BY [컬럼명]으로 했을 때 아래의 결과와 같이 NULL을 포함하고 집계한다.
                                        ^^^^^^^^^
   SELECT B FROM T GROUP BY B HAVING COUNT(*) > 1;

GROUP BY절을 쓰지 않고 전체 집계 할 때는 NULL 값을 제외하고 집계한다.
                                 ^^^^^^^^^^^^^
   SELECT B FROM T GROUP BY B HAVING COUNT(*) > 1;
*/