/*
* 용도       : PNP정산시스템 고도화 프로젝트
* 생성자     : 문성진 부장님
* 저장일     : 2022-01-25
*/

CREATE TABLE PMPBMIG.MSJ_MIG_JOB_LOG
(
    TABLE_NAME      VARCHAR2(128),
    MIG_START_DT    DATE,
    MIG_END_DT      DATE,
    MIG_COUNT       NUMBER,
    JOB_RESULT      VARCHAR2(4000)         -- 전환 성공하면 'SUCCESS'. 실패하면 오류코드
)
TABLESPACE TS_PMPBMIG_D01
NOCOMPRESS;