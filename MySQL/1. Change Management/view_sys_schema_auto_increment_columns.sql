-- AUTO_INCREMENT 칼럼이 존재하는 테이블들에 대해 해당 칼럼의 현재 및 최댓값, 값 사용률 (시퀀스가 사용된 정도) 등의 정보 확인
SELECT table_schema
     , table_name
     , column_name
     , data_type
     , column_type
     , is_signed
     , is_unsigned
     , max_value
     , auto_increment
     , auto_increment_ratio
  FROM sys.schema_auto_increment_columns;
