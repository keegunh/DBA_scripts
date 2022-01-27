/*
* 용도       : PNP정산시스템 고도화 프로젝트
* 생성자     : 문성진 부장님
* 저장일     : 2022-01-25
*/

CREATE TABLE PMPBMIG.MSJ_MIG_TABLE
(
    OWNER           VARCHAR2(128),
    TABLE_NAME      VARCHAR2(128),
    TOBE_TABLE_NAME VARCHAR2(128),
    MIG_TYPE        VARCHAR2(1),          -- 이관 유형 코드 : 이관 여부, 등... 이관 대상 테이블 관리할 때 유용하게 사용
    DDL_SYNC_YN     VARCHAR2(1),          -- ASIS, TOBE 형상이 동일한지. 1대1로 가도 되는지 여부
    MIG_SQL         VARCHAR2(4000),       -- where 조건절. 끝에 semicolon 없음
    INST_ID         NUMBER,               -- session 번호. 예를 들어 데이터 전환 시 총 8개 세션으로 전환한다면 그 중 몇 번째인지 세션인지
    DATA_SIZE_MEGA  NUMBER,
    DEGREE          NUMBER,               -- degree of prallelism
    MIG_DESC        VARCHAR2(4000),       -- 코멘트. 수정 이유, 전환 제외 이유, 테이블/업무 담당자 등 입력.
    PART_YN         VARCHAR2(1),          -- 파티션 여부
    MIG_SIZE_MEGA   NUMBER,
    TABLESPACE_NAME VARCHAR2(30),
    MIG_ORDER       NUMBER(1)
)
TABLESPACE TS_PMPBMIG_D01
NOCOMPRESS;

CREATE UNIQUE INDEX PMPBMIG.PK_MSJ_MIG_TABLE
ON PMPBMIG.MSJ_MIG_TABLE (TABLE_NAME,MIG_SQL) 
TABLESPACE TS_PMPBMIG_D01;


GRANT ALTER,DELETE,INDEX,INSERT,SELECT,UPDATE,REFERENCES,READ,ON COMMIT REFRESH,QUERY REWRITE,DEBUG,FLASHBACK ON PMPBMIG.MSJ_MIG_TABLE TO PMPBADM;
GRANT SELECT ON PMPBMIG.MSJ_MIG_TABLE TO PMPBDEV;