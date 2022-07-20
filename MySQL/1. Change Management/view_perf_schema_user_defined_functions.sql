-- 컴포넌트나 플러그인에 의해 자동으로 등록됐거나 CREATE FUNCTION 명령문에 의해 생성된 사용자 정의 함수들에 대한 정보 저장
SELECT udf_name
     , udf_return_type
     , udf_type
     , udf_library
     , udf_usage_count
  FROM performance_schema.user_defined_functions;
