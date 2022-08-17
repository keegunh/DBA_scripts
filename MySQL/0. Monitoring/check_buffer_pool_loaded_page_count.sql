-- 버퍼 풀의 적재 내용 확인
-- 테이블의 인덱스별로 데이터 페이지가 얼마나 InnoDB 버퍼 풀에 적재돼 있는지 확인
SELECT it.name table_name
     , ii.name index_name
	 , ici.n_cached_pages n_cached_pages
  FROM information_schema.innodb_tables it
 INNER JOIN information_schema.innodb_indexes ii
    ON ii.table_id = it.table_id
 INNER JOIN information_schema.innodb_cached_indexes ici
    ON ici.index_id = ii.index_id
 WHERE it.name = CONCAT('SCHEMA_NAME','/','TABLE_NAME')
;

-- 테이블 전체(인덱스 포함) 페이지 중에서 대략 어느 정도 비율이 InnoDB 버퍼 풀에 적재돼 있는지 확인
-- 조건절 없이 조회하면 오류 발생함 (BIGINT UNSIGNED value is out of range)
SELECT (SELECT SUM(ici.n_cached_pages) AS n_cached_pages
          FROM information_schema.innodb_tables it
         INNER JOIN information_schema.innodb_indexes ii
            ON ii.table_id = it.table_id
         INNER JOIN information_schema.innodb_cached_indexes ici
            ON ici.index_id = ii.index_id
         WHERE it.name = CONCAT(t.table_schema, '/', t.table_name)) AS total_cached_pages
     , (t.data_length + t.index_length - t.data_free) / @@innodb_page_size AS total_pages
     -- , t.data_length
     -- , t.index_length
     -- , t.data_free
  FROM information_schema.tables t
 WHERE t.table_schema = 'SCHEMA_NAME'
   AND t.table_name = 'TABLE_NAME'
;