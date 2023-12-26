## TESTDB는 인스턴스명
## LIS_TESTDB는 리스너명 
## LIS_TESTDB는 listener.ora, tnsnames.ora 둘 다 등록되어야 있어야 함
## multi instance 서버이면 인스턴스별로 아래 기동 스크립트를 여러 번 복사해서 수행

ORACLE_SID=TESTDB
echo "ORACLE_SID set to: $ORACLE_SID:"
lsnrctl start LIS_TESTDB
sqlplus / as sysdba << EOF
startup;
EOF

## 리스너 및 인스턴스 기동 확인
ps -ef | grep tns
ps -ef | grep pmon