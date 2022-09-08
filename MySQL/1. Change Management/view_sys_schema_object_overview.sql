-- 데이터베이스별로 해당 데이터베이스에 존재하는 객체들의 유형(테이블, 프로시저, 트리거 등) 별 객체 수 정보 확인
SELECT db
     , object_type
     , count
  FROM sys.schema_object_overview;