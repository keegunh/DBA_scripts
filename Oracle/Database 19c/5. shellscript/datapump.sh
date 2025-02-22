## 기본 옵션
# USER/PW : 데이터베이스 유저 및 비밀번호
# DIRECTORY : DATAPUMP FILE을 저장하는 디렉토리 (반드시 DBA_DIRECTORIES에 존재하는 DIRECTORY_NAME을 사용해야 함)
# DUMPFILE : DATAPUMP에 의해 생성 될 DUMPFILE 이름
# LOGFILE : DATAPUMP에 의해 생성 될  LOGFILE 이름
# SCHEMAS : SCHEMA가 소유한 objects 를 EXPORT 
# TABLES : 명시된 TABLE 에 대해서만 EXPORT
# PARALLEL : 병렬 IMP/EXP 프로세스 수
# PARFILE : 옵션 지정해둔 파라미터 파일 지정 (지정할 옵션이 
# EXCLUDE : 제외할 오브젝트 목록 또는 오브젝트 유형 명시
# INCLUDE : 포함할 오브젝트 목록 또는 오브젝트 유형 명시

## EXPDP 옵션
# FULL : DATABASE 전체를 EXPORT 여부 결정  YES/NO (default : NO)
# 참고 : https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-data-pump-export-utility.html#GUID-33880357-06B1-4CA2-8665-9D41347C6705

## IMPDP 옵션
# REMAP_SCHEMA : IMPORT 시 스키마 변경
# REMAP_TABLESPACE : IMPORT 시 테이블스페이스 변경
# REMAP_TABLE : IMPORT 시 테이블 변경
# TABLE_EXISTS_ACTION : IMPORT 시 테이블이 이미 있으면 {SKIP|APPEND|TRUNCATE|REPLACE} 중 하나의 작업 수행
# TRANSFORM : 주로 SEGMENT_ATTRIBUTES:N 형태로 사용. 
# 참고 : https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/datapump-import-utility.html#GUID-BA74D4F6-2840-4002-A673-0A7D9CBB3D78

## 예시 1
expdp USER/"PW" directory=DATA_PUMP_DIR dumpfile=dumpfile_name_%U.dmp logfile=dumpfile_name_exp.log parallel=4 full=y exclude=schema:"IN ('WMSYS', 'OUTLN')"

## 예시 2
impdp USER/"PW" directory=DATA_PUMP_DIR dumpfile=dumpfile_name_%U.dmp logfile=dumpfile_name_imp.log parallel=4 \ 
schemas=A,B,C remap_schema=A:D,B:E transform=segment_attributes:n exclude=index

## 예시 3
cat << EOF > IMP_DBID.par
job_name=example_import
directory=DATA_PUMP_DIR
dumpfile_name_%U.dmp
logfile=dumpfile_name_imp.log
parallel=4
tables=A.A,A.B,B.B
EOF
impdp USER/"PW" parfile=IMP_DBID.par

## 예시 4
nohup impdp USER/"PW" parfile=IMP_DBID.par &

## DATAPUMP 작업 취소
# ps -ef | grep impdp / expdp 로 프로세스 ID 조회해서 Kill -9을 한다고 실제 프로세스가 죽지 않는다.
# DATAPUMP 작업을 제어하려면 반드시 프롬프트 창에서 제어해야 한다.

# DATAPUMP 프롬프트 진입 방법:
# 1. IMP/EXP 작업 중 CTRL-C를 누르면 export> 프롬프트, import> 프롬프트 형식으로 대화형 명령모드가 가능하다. 이 때 진행되던 작업이 취소되지는 않는다.
# 2. attach 키워드와 log에 남아있는 JOB_NAME으로 진입
#     예시) expdp [ID]/[PW] attach=JOB_NAME
# 		JOB_NAME을 명시하지 일반적으로 SYS_EXPORT_SCHEMA_01 log파일에서 Starting "SYSTEM"."SYS_EXPORT_SCHEMA_01": ..... 와 같이 확인 간으하다.
#       log파일이 없으면 DBA_DATAPUMP_JOBS 에서 확인 가능하다.

# 프롬프트에서 사용할 수 있는 명령어:
# 1. CONTINUE_CLIENT
#  - 로그 출력이 화면에 다시 표시되는 일반 클라이언트로 다시 전환
# 2. EXIT_CLIENT
#  - 클라이언트는 닫히지만 데이터베이스 작업은 계속되므로 작업이 정상적으로 완료됨
# 3. KILL_JOB
#  - 모든 클라이언트를 분리하고 데이터베이스 작업을 종료(attach 되어 있는 job을 detach시키고 현재 돌아가는 job 중지)
# 4. STOP_JOB
#  - 기본적으로 현재 작업이 완료된 후 작업이 중지되고 나중에 재개할 수 있다.
# 5. START_JOB
#  - 중지된 작업을 다시 시작(attach되어 있는 job을 시작 가능)
# 6. STATUS
#  - 작업자의 상태를 포함하여 작업에 대한 기본 정보 표시
#
# 예시) export> KILL_JOB      -> 현재 attach되어 있는 export JOB을 종료한다
