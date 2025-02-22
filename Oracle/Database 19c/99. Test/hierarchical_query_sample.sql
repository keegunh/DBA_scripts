/*
[START WITH 조건1] [CONNECT BY 조건2]
START WITH 조건1 : 루트노드를 식별한다. 조건1을 만족하는 모든 ROW들은 루트노드가 된다.
                  START WITH 절을 생략할 수도 있는데 이러한 경우 모든 ROW들을 루트노드로 간주한다.
                  조건1에는 서브쿼리도 올 수 있다.
CONNECT BY 조건2 : 부모와 자식노드들 간의 관계를 명시하는 부분.
                  조건2에는 반드시 PRIOR 연산자를 포함시켜야 하며 이는 부모노드의 컬럼을 식별하는 데 사용된다.
                  조건2에서는 서브쿼리가 올 수 없다.

PRIOR 연산자 : 오직 계층형 쿼리에서만 사용하는 오라클 SQL 연산자. 키워드라고 표현했지만 실제로는 CONNECT BY 절에서 등호(=)와 동등한 레벨로 사용되는 연산자이며
CONNECT BY 절에서 해당 컬럼의 부모로우를 식별하는데 사용된다.
아래 예에서 본체의 PARENT_ID 컬럼에는 컴퓨터의 ITEM_ID 값을 가지고 있으므로 PRIOR 연산자는 ITEM_ID 앞에 붙게 된다.

LEVEL Pseudocolumn : 계층형 정보를 표현할 때 레벨을 나타낸다. LEVEL도 일반적인 컬럼처럼 SELECT, WHERE, ORDER BY 절에서 사용할 수 있다.
ORDER BY SIBLINGS : 계층구조를 그대로 유지하면서 동일 상위계층을 가진 하위계층끼리의 정렬기준을 줌.
                    ORDER BY 절로는 안 되는 게 그렇게 정렬을 할 경우 계층구조가 흐트러짐.
SYS_CONNECT_BY_PATH() : 계층형 쿼리에서만 사용 가능한 함수. 루트 노드에서 시자갷서 자신의 행까지 연결된 정보를 반환함.
CONNECT_BY_ROOT {컬럼명} : 해당 ROW의 루트로 지정된 ROW의 "컬럼명" 반환
CONNECT_BY_ISLEAF : 해당 ROW의 LEAF여부 반환
*/

WITH BOM AS (
SELECT 1001 AS ITEM_ID, NULL AS PARENT_ID, '컴퓨터' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
 UNION ALL
SELECT 1002 AS ITEM_ID, 1001 AS PARENT_ID, '본체' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
 UNION ALL
SELECT 1003 AS ITEM_ID, 1001 AS PARENT_ID, '모니터' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
 UNION ALL
SELECT 1004 AS ITEM_ID, 1001 AS PARENT_ID, '프린터' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
 UNION ALL
SELECT 1005 AS ITEM_ID, 1002 AS PARENT_ID, '메인보드' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
 UNION ALL
SELECT 1006 AS ITEM_ID, 1002 AS PARENT_ID, '랜카드' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
 UNION ALL
SELECT 1007 AS ITEM_ID, 1002 AS PARENT_ID, '파워서플라이' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
 UNION ALL
SELECT 1008 AS ITEM_ID, 1005 AS PARENT_ID, 'CPU' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
 UNION ALL
SELECT 1009 AS ITEM_ID, 1005 AS PARENT_ID, 'RAM' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
 UNION ALL
SELECT 1010 AS ITEM_ID, 1005 AS PARENT_ID, '그래픽카드' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
 UNION ALL
SELECT 1011 AS ITEM_ID, 1005 AS PARENT_ID, '기타장치' AS ITEM_NAME, 1 AS ITEM_QTY FROM DUAL
)
SELECT ITEM_ID, ITEM_NAME, PARENT_ID, LEVEL
     , LPAD(' ', 3*(LEVEL-1)) || ITEM_NAME AS ITEM_NAMES
	 , SYS_CONNECT_BY_PATH(ITEM_NAME, '/') AS PATH
	 , CONNECT_BY_ISLEAF
	 , CONNECT_BY_ROOT ITEM_NAME AS ROOT_ITEM_NAME
  FROM BOM
 START WITH PARENT_ID IS NULL -- 루트노드를 지정
CONNECT BY PRIOR ITEM_ID = PARENT_ID; -- 부모와 자식노드들 간의 관계를 연결