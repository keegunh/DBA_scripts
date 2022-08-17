/*
	MySQL 5.6 버전부터는 InnoDB 스토리지 엔진을 사용하는 테이블에 대한 통계 정보를 영구적으로 관리할 수 있개 개선됨.
	(그 전까지는 통계 정보가 메모리에만 관리됨.)
	
	STATS_PERSISTENT
		테이블 생성 시 옵션으로 STATS_PERSISTENT 값을 지정할 수 있으며 지정하지 않을 시 @@innodb_stats_persistent DB파라미터에 따라 지정된다.
		1로 설정하면 영구 통계를 수집하고 0으로 설정하면 수집하지 않는다.
	
		CREATE TABLE tab_persistent (fd1 INT PRIMARY KEY, fd2 INT)
		ENGINE=InnoDB STATS_PERSISTENT=1;
		
	STATS_AUTO_RECALC
		테이블 생성 시 옵션으로 STATS_AUTO_RECALC 값을 지정할 수 있으면 지정하지 않을 시 @@innodb_stats_auto_recalc DB파라미터에 따라 지정된다.
		1로 설정하면 통계정보를 자동으로 통계 정보가 갱신된다.

		CREATE TABLE tab_persistent (fd1 INT PRIMARY KEY, fd2 INT)
		ENGINE=InnoDB STATS_AUTO_RECALC=1;
		
		통계 정보 갱신되는 이벤트 목록
			1. 테이블이 새로 오픈되는 경우
			2. 레코드가 대량으로 변경되는 경우 (테이블의 전체 레코드 주에서 1/16 정도의 UPDATE / INSERT / DELETE)
			3. analyze table 명령이 실행되는 경우
			4. SHOW TABLE STATUS 명령이나 SHOW INDEX FROM 명령이 실행되는 경우
			5. InnoDB 모니터가 활성화되는 경우
			6. innodb_stats_on_metadata 시스템 설정이 ON인 상태에서 SHOW TABLE STATUS 명령이 실행되는 경우
			
	
	통계 정보 값들에 대한 설명
		innodb_index_stats.stat_name = 'n_diff_pfx%' : 인덱스가 가진 유니크한 값의 개수
		innodb_index_stats.stat_name = 'n_leaf_pages' : 인덱스의 리프 노드 페이지 개수
		innodb_index_stats.stat_name = 'size' : 인덱스 트리의 전체 페이스 개수
		innodb_table_stats.n_rows : 테이블의 전체 레코드 건수
		innodb_table_stats.clustered_index_size : PK의 크기 (InnoDB 페이지 개수)
		innodb_table_stats.sum_of_other_index_sizes : PK를 제외한 인덱스의 크기 (InnoDB 페이지 개수)
*/

-- MySQL 서버 통계 정보
SELECT database_name
     , table_name
	 , last_update
	 , n_rows
	 , clustered_index_size
	 , sum_of_other_index_sizes
  FROM mysql.innodb_table_stats
;

SELECT database_name
     , table_name
	 , index_name
	 , last_update
	 , stat_name
	 , stat_value
	 , stat_description
  FROM mysql.innodb_index_stats
;