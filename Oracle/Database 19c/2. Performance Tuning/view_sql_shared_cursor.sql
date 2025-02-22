/*
LIBRARY CACHE와 공유 커서에서 하나의 SQL 문장이 여러 개 CHILD CURSOR를 갖게 되는 이유
	1. SQL에서 참조하는 오브젝트명이 같지만 SQL을 실행한 사용자에 따라 다른 오브젝트를 가리킬 때
	2. 참조 오브젝트가 변경돼 커서가 무효화되면 이후 그 커서를 처음 사용하려는 세션에 의해 다시 파싱돼야 하는데, 특정 세션이 아직 기존 커서를 사용 중(PIN)일 때
	3. 옵티마이저 모드를 비롯해 옵티마이저 관련 파라미터가 다를 때
	4. 입력된 바인드 값의 길이가 크게 다를 때
	5. NLS 파라미터를 다르게 설정했을 때
	6. SQL 트레이스를 활성화했을 때

V$SQLAREA에서 VERSION_COUNT 수치가 높은 SQL일수록 커서를 탐색하는 데 더 많은 시간을 소비하므로 LIBRARY CACHE 래치에 대한 경합 가능성을 증가시킨다.
SQL 하나당 여러 개의 CHILD CURSOR를 가지면 성능에 안 좋다. (LIBRARY CACHE 경합)

공유돼 있던 커서는 다음과 같은 이유로 무효화될 수 있다. 그러면 해당 SQL에 대한 하드파싱이 다시 일어난다.
	1. 커서가 참조하고 있던 오브젝트에 컬럼이 추가 / 삭제
	2. 커서가 참조하고 있던 오브젝트에 대한 인덱스 생성 / 삭제
	3. 커서가 참조하고 있던 오브젝트에 대한 통계 재수집
	4. 기타 DDL
*/

SELECT SQL_ID, VERSION_COUNT, OPTIMIZER_MODE, ADDRESS, HASH_VALUE
  FROM V$SQLAREA
 ORDER BY VERSION_COUNT DESC;
 
SELECT SQL_ID, CHILD_NUMBER, OPTIMIZER_MODE, ADDRESS, HASH_VALUE, PARSING_USER_ID
  FROM V$SQL;
  
-- 아래 쿼리는 새로운 CHILD CURSOR가 왜 기존 CHILD CURSOR와 공유되지 못햿는지 설명
SELECT * FROM V$SQL_SHARED_CURSOR;