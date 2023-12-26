## 기본 옵션
# USER/PW : 데이터베이스 유저 및 비밀번호
# DIRECTORY : DATAPUMP FILE을 저장하는 디렉토리
# DUMPFILE : DATAPUMP에 의해 생성 될 DUMPFILE 이름
# LOGFILE : DATAPUMP에 의해 생성 될  LOGFILE 이름
# SCHEMAS : SCHEMA가 소유한 objects 를 EXPORT 
# TABLES : 명시된 TABLE 에 대해서만 EXPORT
# PARALLEL : 병렬 IMP/EXP 프로세스 수
# PARFILE : 옵션 지정해둔 파라미터 파일 지정

## EXPDP 옵션
# FULL : DATABASE 전체를 EXPORT 여부 결정  YES/NO (default : NO)
# 참고 : https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/oracle-data-pump-export-utility.html#GUID-33880357-06B1-4CA2-8665-9D41347C6705

## IMPDP 옵션
# REMAP_SCHEMA : IMPORT 시 스키마 변경
# REMAP_TABLESPACE : IMPORT 시 테이블스페이스 변경
# REMAP_TABL : IMPORT 시 테이블 변경
# TABLE_EXISTS_ACTION : IMPORT 시 테이블이 이미 있으면 {SKIP|APPEND|TRUNCATE|REPLACE} 중 하나의 작업 수행
# TRANSFORM : 주로 SEGMENT_ATTRIBUTES:N 형태로 사용. 
# 참고 : https://docs.oracle.com/en/database/oracle/oracle-database/19/sutil/datapump-import-utility.html#GUID-BA74D4F6-2840-4002-A673-0A7D9CBB3D78

## 예시 1
expdp USER/"PW" directory=DATA_PUMP_DIR dumpfile=dumpfile_name_%U.dmp logfile=dumpfile_name_exp.log parallel=4 full=y

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
