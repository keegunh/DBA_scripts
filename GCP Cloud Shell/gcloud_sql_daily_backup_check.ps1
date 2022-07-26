## POWERSHELL
## 매일 운영DB 백업 정상 생성 여부 확인

# cd "D:\2022 공통업무 상향 평준화 HR Core 프로젝트\스크립트\dba_private\GCP Cloud Shell\gcloud_sql_backups_list_result"
cd C:\Users\80517\Desktop\backup_log
$TodayUTC = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")
echo "GCP Cloud SQL Production DB Daily Backup Check" > BACKUP-CHECK-${TodayUTC}.txt
echo "Today's UTC date is ${TodayUTC}" >> BACKUP-CHECK-${TodayUTC}.txt

## PRD JJOBS
gcloud config set project pjt-hrcore-prd-316104
gcloud sql backups list --instance=csql-an3-hrcore-jjobs-prd-postgres --filter="WINDOW_START_TIME>=${TodayUTC}" --sort-by=~WINDOW_START_TIME 1>> BACKUP-CHECK-${TodayUTC}.txt

## PRD SPICEWARE
gcloud sql backups list --instance=csql-an3-hrcore-spiceware-prd-mysql --filter="WINDOW_START_TIME>=${TodayUTC}" --sort-by=~WINDOW_START_TIME | Select -Index 1 >> BACKUP-CHECK-${TodayUTC}.txt

## PRD CORE
gcloud sql backups list --instance=csql-an3-hrcore-core-prd-mysql --filter="WINDOW_START_TIME>=${TodayUTC}" --sort-by=~WINDOW_START_TIME | Select -Index 1 >> BACKUP-CHECK-${TodayUTC}.txt

## PRD PORTAL
gcloud sql backups list --instance=csql-an3-hrcore-portal-prd-mysql --filter="WINDOW_START_TIME>=${TodayUTC}" --sort-by=~WINDOW_START_TIME | Select -Index 1 >> BACKUP-CHECK-${TodayUTC}.txt

## PRD LGC
gcloud config set project pjt-hrcore-prd-lgc
gcloud sql backups list --instance=csql-an3-hrcore-lgc-prd-mysql --filter="WINDOW_START_TIME>=${TodayUTC}" --sort-by=~WINDOW_START_TIME | Select -Index 1 >> BACKUP-CHECK-${TodayUTC}.txt

## PRD LGCNS
gcloud config set project pjt-hrcore-prd-cns
gcloud sql backups list --instance=csql-an3-hrcore-cns-prd-mysql --filter="WINDOW_START_TIME>=${TodayUTC}" --sort-by=~WINDOW_START_TIME | Select -Index 1 >> BACKUP-CHECK-${TodayUTC}.txt

## PRD LGES
gcloud config set project pjt-hrcore-prd-lges
gcloud sql backups list --instance=csql-an3-hrcore-lges-prd-mysql --filter="WINDOW_START_TIME>=${TodayUTC}" --sort-by=~WINDOW_START_TIME | Select -Index 1 >> BACKUP-CHECK-${TodayUTC}.txt

$Instance_Total = 7
# -3는 앞에 echo 2건, HEADER line 1건 총 3건
if ( ((cat ./BACKUP-CHECK-${TodayUTC}.txt).Length - 3) -eq $Instance_Total ) {
	echo "`nSUCCESS : All production instances successfully created daily automated backups`n" >> BACKUP-CHECK-${TodayUTC}.txt
} else {
	echo "`nERROR : some instances failed to create daily automated backups`n" >> BACKUP-CHECK-${TodayUTC}.txt
}

cat BACKUP-CHECK-${TodayUTC}.txt
