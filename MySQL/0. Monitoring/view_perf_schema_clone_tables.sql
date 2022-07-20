/*
*	Clone 테이블들은 Clone 플러그인을 통해 수행되는 복제 작업에 대한 정보를 제공.
*	Clone 테이블들은 MySQL 서버에 Clone 플러그인이 설치될 때 자동으로 생성되고,
*	플러그인이 삭제될 때 마찬가지로 함께 제거됨.
*/

-- 현재 또는 마지막으로 실행된 클론 작업에 대한 상태 정보 확인
performance_schema.clone_status;


-- 현재 또는 마지막으로 실행된 클론 작업에 대한 진행 정보 확인
performance_schema.clone_progress;