# 일일 백업 정상 생성 여부 확인
$TimeNow = Get-Date
$TimeToday = $TimeNow.ToString("yyyyMMdd")
$TimeYest = (Get-Date).AddDays(-1)
get-date $TimeYest -f "yyyy-MM-dd HH:mm:ss"
$TimeYest.ToUniversalTime().ToString("yyyy-MM-dd")

$Dir="D:\2022 공통업무 상향 평준화 HR Core 프로젝트\스크립트\dba_private\GCP Cloud Shell\gcloud_sql_backups_list_result"

gcloud sql backups list --project=pjt-hrcore-prd-316104 --instance=csql-an3-hrcore-core-prd-mysql | Select-Object -first 1 > $Dir\BACKUP_CHK_$TimeToday.txt
gcloud sql backups list --project=pjt-hrcore-prd-316104 --instance=csql-an3-hrcore-core-prd-mysql |  findstr $TimeYest.ToUniversalTime().ToString("yyyy-MM-dd") >> $Dir\BACKUP_CHK_$TimeToday.txt
gcloud sql backups list --project=pjt-hrcore-prd-316104 --instance=csql-an3-hrcore-portal-prd-mysql |  findstr $TimeYest.ToUniversalTime().ToString("yyyy-MM-dd") >> $Dir\BACKUP_CHK_$TimeToday.txt
gcloud sql backups list --project=pjt-hrcore-prd-316104 --instance=csql-an3-hrcore-spiceware-prd-mysql |  findstr $TimeYest.ToUniversalTime().ToString("yyyy-MM-dd") >> $Dir\BACKUP_CHK_$TimeToday.txt
gcloud sql backups list --project=pjt-hrcore-prd-316104 --instance=csql-an3-hrcore-jjobs-prd-postgres |  findstr $TimeYest.ToUniversalTime().ToString("yyyy-MM-dd") >> $Dir\BACKUP_CHK_$TimeToday.txt
gcloud sql backups list --project=pjt-hrcore-prd-lgc --instance=csql-an3-hrcore-lgc-prd-mysql |  findstr $TimeYest.ToUniversalTime().ToString("yyyy-MM-dd") >> $Dir\BACKUP_CHK_$TimeToday.txt
gcloud sql backups list --project=pjt-hrcore-prd-lges --instance=csql-an3-hrcore-lges-prd-mysql |  findstr $TimeYest.ToUniversalTime().ToString("yyyy-MM-dd") >> $Dir\BACKUP_CHK_$TimeToday.txt
gcloud sql backups list --project=pjt-hrcore-prd-cns --instance=csql-an3-hrcore-cns-prd-mysql |  findstr $TimeYest.ToUniversalTime().ToString("yyyy-MM-dd") >> $Dir\BACKUP_CHK_$TimeToday.txt
