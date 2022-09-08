-- 인덱스 칼럼 구성이 동일한 테이블 내 다른 인덱스의 칼럼 구성과 중복되는 인덱스에 대한 정보 확인
-- 인덱스를 구성하는 칼럼들의 순서가 동일해야 중복된 인덱스루 간주
-- 칼럼 구성이 오나전히 동일해야 하는 것이 아니라 포함 관계인 경우도 해당

-- 인덱스의 중복 여부는 인덱스를 구성하고 있는 칼럼에 대해 두 인덱스의 칼럼 구성 순서가 일치하고 어느 한쪽이 다른 한쪽에 포함되는지를 바탕으로 결정된다.
-- "redundant_"로 시작하는 칼럼들에는 중복된 것으로 간주되는 인덱스의 정보가 표시됨.
-- "dominant_"로 시작하는 칼럼들에는 중복된 인덱스를 중복으로 판단되게 한 인덱스의 정보가 표시됨.

SELECT table_schema
     , table_name
     , redundant_index_name
     , redundant_index_columns
     , redundant_index_non_unique
     , dominant_index_name
     , dominant_index_columns
     , dominant_index_non_unique
     , subpart_exists
     , sql_drop_index
  FROM sys.schema_redundant_indexes;
