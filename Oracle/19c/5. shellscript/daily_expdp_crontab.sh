# sql> SELECT * FROM DBA_DIRECTORIES;
# sql> CREATE OR REPLACE DIRECTORY DATA_PUMP_DIR AS '/work001/DATAPUMP';
# sql> GRANT READ, WRITE ON DIRECTORY DATA_PUMP_DIR TO PUBLIC;
# sql> SELECT * FROM DBA_DIRECTORIES;

cat << EOF > /oracle/HKG_scripts/sh/backup_POP.sh
#!/usr/bin/ksh

####################################
# SET VARIABLE INFO                #
####################################
export ORACLE_BASE=/oracle/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/19.3
export PATH=$PATH:$ORACLE_HOME/bin:$ORACLE_HOME/OPatch:$ORACLE_HOME/jdk/bin:$ORACLE_HOME/jdbc/lib/ojdbc8.jar:
export JAVA_COMPILER=NONE
export LC_ALL=American_America.AL32UTF8
export NLS_LANG=American_America.AL32UTF8
export ORACLE_SID=PPSD

#sid=$ORACLE_SID
sid='PPSD'
today=$(date '+%Y%m%d')
datapumpdir='/work001/DATAPUMP'

prev3days=`TZ=KST+63;date +%Y%m%d`
yesterday=`TZ=KST+15;date +%Y%m%d`

echo "INSTANCE SET TO SID: $sid"
echo "BACKUP DATE: $today"
echo "DATA_PUMP_DIRECTORY: $datapumpdir"

cd $datapumpdir

####################################
# CREATE EXPDP PARAMETER FILE      #
####################################
filename=BACKUP_$sid"_"$today
cat << EOPARF > $filename.par
job_name=$filename
dumpfile=$filename.dmp
logfile=$filename.log
directory=DATA_PUMP_DIR
schemas=POP_ADM
#tables=<personalInfoTables>
EOPARF
echo "CREATED .par FILE: $filename.par"

####################################
# EXECUTE EXPDP                    #
####################################
command="expdp system/oracle parfile=$filename.par"
echo "EXPORT COMMAND :" $command
echo $($command)
echo "EXPORTING..."
#expdp system/oracle parfile=$filename.par


echo "EXPORT COMPLETE. CREATED DUMP & LOG FILES IN:"
ls -al | grep $filename

####################################
# REMOVE PREVIOUS DUMPFILES        #
####################################
delfilename=BACKUP_$sid"_"$prev3days
echo "DELETING FILES: $delfilename.log $delfilename.dmp $delfilename.par"
rm -f $delfilename.log $delfilename.dmp $delfilename.par
echo "DELETE COMPLETE"
cd -

EOF
. /oracle/HKG_scripts/sh/backup_POP.sh



crontab -l
crontab -e
00 00 * * * /usr/bin/sh /oracle/HKG_scripts/sh/backup_POP.sh >> /oracle/HKG_scripts/sh/backup_POP_log.txt

ll /work001/DATAPUMP | grep PPSD
rm /work001/DATAPUMP/*PPSD*



tail -f /oracle/HKG_scripts/sh/backup_POP_log.txt
