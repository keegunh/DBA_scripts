-- AUTO_INCREMENT 칼럼이 존재하는 테이블들에 대해 해당 칼럼의 현재 및 최댓값, 값 사용률 (시퀀스가 사용된 정도) 등의 정보 확인
-- current_value 칼럼은 테이블에 저장된 auto_increment 칼럼의 가장 큰 값의 다음 순번 값을 나타내며,
-- 이 값과 auto_increment 칼럼에 저장 가능한 최댓값(max_value 칼럼값)을 바탕으로 usage_ratio 칼럼에 사용량이 표시된다.
-- 사용자는 auto_increment 칼럼에 대해 명시적으로 값을 주어 새로운 데이터를 저장할 수 있으므로 실제 테이블의 데이터 건수와 테이블에 저장된 가장 큰 값은 다를 수도 있음.
SELECT table_schema
     , table_name
     , column_name
     , data_type
     , column_type
     , is_signed
     , is_unsigned
     , max_value
	 , ROUND(auto_increment_ratio * 100, 2) AS "usage_ratio"
     , auto_increment
     , auto_increment_ratio
  FROM sys.schema_auto_increment_columns;
