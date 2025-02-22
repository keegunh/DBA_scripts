set today=%date:~0,4%%date:~5,2%%date:~8,2%
echo %today%
expdp system/[PASSWORD] directory=[path name from DBA_DIRECTORIES] dumpfile=[DUMPNAME]_%today%.DMP SCHEMAS=[SCHEMA1,SCHEMA2...] logfile=[LOGNAME]_%today%.log