/*
io_global_by_file_by_bytes 뷰는 기본적으로 파일별로 발생한 읽기 및 쓰기 전체 총량을 기준으로 내림차순으로 정렬해서 결과를 출력
사용자는 해당 뷰에서 테이블 데이터 파일에 대한 데이터들만 선별해서 조회함으로써 MySQL 서버가 구동되는 동안 I/O 요청이 가장 많이 발생한 테이블들을 확인
*/

-- MySQL에서 접근했던 파일별로 읽기 및 쓰기 양에 대한 정보 확인
-- x$io_global_by_file_by_bytes
SELECT file
     , count_read
     , total_read
     , avg_read
     , count_write
     , total_written
     , avg_write
     , total
     , write_pct
  FROM sys.io_global_by_file_by_bytes
 WHERE file LIKE '%ibd';