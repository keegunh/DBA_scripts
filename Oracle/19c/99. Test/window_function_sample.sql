-- WINDOW FUNCTION
/*
 양식:
WINDOW_FUNC() OVER((ROWS/RANGE) BETWEEN {UNBOUNDED PRECEDING   /  EXPRESSION PRECEDING   /   CURRENT ROW}
                                    AND {UNBOUNDED FOLLOWING   /  EXPRESSION FOLLOWING   /   CURRENT ROW})
									
ROWS : 쿼리 결과 상 이전 또는 이후 ROWNUM으로 구분하여 모든 행이 1개의 행으로 인식됨
RANGE: ORDER BY 절에 명시된 컬럼으로 논리적인 행 집합을 구성하며, 집합으로 묶인 그룹이 1개의 행으로 인식한다.
*/


WITH MONTHLY_SALES AS (
     SELECT 'P001' AS PROD_ID, '2019.10' AS MTH, 'SAMSUNG' AS COMP_NM, 15000 AS SALE_AMT FROM DUAL
      UNION ALL
     SELECT 'P001' AS PROD_ID, '2019.11' AS MTH, 'SAMSUNG' AS COMP_NM, 25000 AS SALE_AMT FROM DUAL
      UNION ALL
     SELECT 'P002' AS PROD_ID, '2019.10' AS MTH, 'LG' AS COMP_NM, 10000 AS SALE_AMT FROM DUAL
      UNION ALL
     SELECT 'P002' AS PROD_ID, '2019.11' AS MTH, 'LG' AS COMP_NM, 20000 AS SALE_AMT FROM DUAL
      UNION ALL
     SELECT 'P003' AS PROD_ID, '2019.10' AS MTH, 'APPLE' AS COMP_NM, 15000 AS SALE_AMT FROM DUAL
      UNION ALL
     SELECT 'P003' AS PROD_ID, '2019.11' AS MTH, 'APPLE' AS COMP_NM, 10000 AS SALE_AMT FROM DUAL
)
SELECT PROD_ID, MTH, SALE_AMT
     , SUM(SALE_AMT) OVER(PARTITION BY PROD_ID ORDER BY PROD_ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ROW_SAMPLE
     , SUM(SALE_AMT) OVER(PARTITION BY PROD_ID ORDER BY SALE_AMT RANGE BETWEEN 15000 PRECEDING AND 5000 FOLLOWING) AS RANGE_SAMPLE
  FROM MONTHLY_SALES;	 
  
  
-- WINDOW 함수 없는 DBMS에서는 아래와 같이 사용
WITH MONTHLY_SALES AS (
     SELECT 'P001' AS PROD_ID, '2019.10' AS MTH, 'SAMSUNG' AS COMP_NM, 15000 AS SALE_AMT FROM DUAL
      UNION ALL
     SELECT 'P001' AS PROD_ID, '2019.11' AS MTH, 'SAMSUNG' AS COMP_NM, 25000 AS SALE_AMT FROM DUAL
      UNION ALL
     SELECT 'P002' AS PROD_ID, '2019.10' AS MTH, 'LG' AS COMP_NM, 10000 AS SALE_AMT FROM DUAL
      UNION ALL
     SELECT 'P002' AS PROD_ID, '2019.11' AS MTH, 'LG' AS COMP_NM, 20000 AS SALE_AMT FROM DUAL
      UNION ALL
     SELECT 'P003' AS PROD_ID, '2019.10' AS MTH, 'APPLE' AS COMP_NM, 15000 AS SALE_AMT FROM DUAL
      UNION ALL
     SELECT 'P003' AS PROD_ID, '2019.11' AS MTH, 'APPLE' AS COMP_NM, 10000 AS SALE_AMT FROM DUAL
)
-- SELECT PROD_ID, MTH, SALE_AMT
     -- , SUM(SALE_AMT) OVER(PARTITION BY PROD_ID ORDER BY PROD_ID, MTH ROWS BETWEEN UNBOUDNED PRECEDING AND CURRENT ROW)AS CUMULATIVE_SUM
  -- FROM MONTHLY_SALES;
SELECT A.PROD_ID, A.MTH, MIN(A.SALE_AMT) SALE_AMT, SUM(B.SALE_AMT) CUMULATIVE_SUM
  FROM MONTHLY_SALES A
     , MONTHLY_SALES B
 WHERE A.PROD_ID = B.PROD_ID
   AND A.MTH >= B.MTH
 GROUP BY A.PROD_ID, A.MTH
 ORDER BY A.PROD_ID, A.MTH;