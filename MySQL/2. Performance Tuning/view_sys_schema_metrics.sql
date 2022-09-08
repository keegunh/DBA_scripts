/*
MySQL 서버의 전체적인 메트릭 정보 확인. 다음의 항목들 포함 :
	performance_schema.global_status 테이블의 전역 상태 변수
	information_schema.INNODB_METRICS 테이블의 InnoDB 메트릭
	performance_schema에서 수집한 메모리 사용량 정보를 바탕으로 계산한 MySQL 서버의 현재 할당된 메모리 양과 MySQL 서버에서 할당 및 해제한 메모리의 총량
	현재 시각 정보(유닉스 타임스탬프 형식 및 사람이 읽을 수 있는 형태 두 가지로 표시)
*/
SELECT Variable_name
     , Variable_value
     , Type
     , Enabled
  FROM sys.metrics;
