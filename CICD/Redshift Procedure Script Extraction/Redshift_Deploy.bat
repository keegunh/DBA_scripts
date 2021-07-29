

:: 파일 경로는 절대경로로 사용할 것.

:: 개발
SET server=qa.aws.com
SET database=DB
SET port=1234
SET username=devuser
SET PGPASSWORD=dev123$
SET PGCLIENTENCODING=UTF8

SET HHMMSS=%TIME: =0%
SET DATETIME=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%%HHMMSS:~0,2%%HHMMSS:~3,2%%HHMMSS:~6,2%
SET DATE=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%

ECHO %server% / %database% / %username%
:: DB 접속 : "[psql 경로]\psql.exe" -h %server% -U %username% -d %database% -p %port% -P tuples_only -a -b
:: testrun
:: "[psql 경로]\psql.exe" -h %server% -U %username% -d %database% -p %port% -P tuples_only -a -b -f Redshift_testrun.sql -o .\log\Redshift_testrun_%DATETIME%.out


:: 0. 배포할 프로시저를 Redshift_procedures_to_deploy.txt 에 복사

:: 1. python script 실행 -> show procedure 생성 -> Redshift_show_procedures_%DATE%.sql 파일 생성
"[파이썬 경로]\Python.exe" Redshift_show_procedures.py

:: 2. #1 에서 생성한 Redshift_show_procedures_%DATE%.sql 파일을 실행 후 결과 파일 Redshift_deploy_%DATE%.sql (show procedure 결과)도출
"[psql 경로]\psql.exe" -h %server% -U %username% -d %database% -p %port% -a -b -e -f 1-Redshift_show_procedures_%DATE%.sql -o 2-Redshift_deploy_%DATE%.sql -L .\log\1-Redshift_show_procedures_%DATE%.log

:: 3. #2에서 도출한 Redshift_deploy_%DATE%.sql 를 python 으로 가공하여 실행할 수 있는 형태로 변경 + 권한 부여 추가 -> 최종 배포 DDL 스크립트 도출 Redshift_deploy_final_YYYYMMDD.sql
"[파이썬 경로]\Python.exe" Redshift_make_DDL.py



:: 운영
:: SET server=prod.aws.com
:: SET database=DB
:: SET port=1234
:: SET username=deploy
:: SET PGPASSWORD=deploy123$
:: SET PGCLIENTENCODING=UTF8

:: 4. 최종 배포 DDL 스크립트 실행
:: "[psql 경로]\psql.exe" -h %server% -U %username% -d %database% -p %port% -a -b -e -f 3-Redshift_deploy_final_%DATE%.sql -o .\log\4-Redshift_deploy_final_%DATE%.out -L .\log\4-Redshift_deploy_final_%DATE%.log