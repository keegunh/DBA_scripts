-- 코스트 모델 (COST_MODEL)
/*
	전체 쿼리의 비용을 계산하는 데 필요한 단위 작업들의 비용을 코스트 모델(Cost Model) 이라고 한다.
	cost_name : 코스트 모델의 각 단위 작업
	default_value : 각 단위 작업의 비용 (기본값이며, 이 값은 MySQL 서버 소스에 설정된 값)
	cost_value : DBMS 관리자가 설정한 값(이 값이 NULL이면 MySQL 서버는 default_value 칼럼의 비용 사용)
	last_update : 단위 작업의 비용이 변경된 시점
	comment : 비용에 대한 추가 설명
	
	engine_name : 비용이 적용된 스토리지 엔진
	device_type : 디스크 타입
	
	engine_cost 
		cost_name						default_value	설명
		io_block_read_cost				1.00			디스크 데이터 페이지 읽기
		memory_block_read_cost			0.25			메모리 데이터 페이지 읽기
		
	server_cost							default_value	설명
		disk_temptable_create_cost		20.00			디스크 임시 테이블 생성
		disk_temptable_row_cost			0.50			디스크 임시 테이블의 레코드 읽기
		key_compare_cost				0.05			인덱스 키 비교
		memory_temptable_create_cost	1.00			메모리 임시 테이블 생성
		memory_temptable_row_cost		0.10			메모리 임시 테이블의 레코드 읽기
		row_evaluate_cost				0.10			레코드 비교
		
	변경 가이드
	- key_compare_cost 비용을 높이면 MySQL 서버 옵티마이저가 가능하면 정렬을 수행하지 않는 방ㄴ향의 실행 계획을 선택할 가능성이 높아진다.
	- row_evaluate_cost 비용을 높이면 풀 스캔을 실행하는 쿼리들의 비용이 높아지고, MySQL 서버 옵티마이저는 가능하면 인덱스 레인지 스캔을 사용하는 실행 계획을 선택할 가능성이 높아진다.
	- disk_temptable_create_cost와 disk_temptable_row_cost 비용을 높이면 MySQL 옵티마이저는 디스크에 임시 테이블을 만들지 않는 방향의 실행 계획을 선택할 가능성이 높아진다.
	- memory_temptable_create_cost와 memory_temptable_row_cost 비용을 높이면 MySQL 옵티마이저는 메모리 임시 테이블을 만들지 않는 방향의 실행 계획을 선택할 가능성이 높아진다.
	- io_block_read_cost 비용이 높아지면 MySQL 서버 옵티마이저는 가능하면 InnoDB 버퍼 풀에 데이터 페이지가 많이 적재돼 있는 인덱스를 사용하는 실행 계획을 선택할 가능성이 높아진다.
	- memory_block_read_cost 비용이 높아지면 MySQL 서버는 InnoDB 버퍼 풀에 적재된 데이터 페이지가 상대적으로 적다고 하더라도 그 이넫ㄱ스를 사용할 가능성이 높아진다.
*/

-- server cost : 인덱스를 찾고 레코드를 비교하고 임시 테이블 처리에 대한 비용 관리
SELECT cost_name
     , cost_value
	 , last_update
	 , comment
	 , default_value
  FROM mysql.server_cost
;

-- engine cost : 레코드를 가진 데이터 페이즈를 가져오는 데 필요한 비용 관리
SELECT engine_name
     , device_type
	 , cost_name
     , cost_value
	 , last_update
	 , comment
	 , default_value
  FROM mysql.engine_cost
;