## POWERSHELL
## 매일 운영DB 정상 기동 여부 확인

cd C:\Users\80517\Desktop\daily_check\status_log
$TodayUTC = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd")
echo "GCP Cloud SQL Production DB Daily Status Check" > STATUS-CHECK-${TodayUTC}.txt
echo "Today's UTC date is ${TodayUTC}" >> STATUS-CHECK-${TodayUTC}.txt

## PRD JJOBS, SPICEWARE, CORE, PORTAL
gcloud config set project pjt-hrcore-prd-316104
gcloud sql instances list >> STATUS-CHECK-${TodayUTC}.txt

## PRD LGCNS
gcloud config set project pjt-hrcore-prd-cns
gcloud sql instances list >> STATUS-CHECK-${TodayUTC}.txt

## PRD LGC
gcloud config set project pjt-hrcore-prd-lgc
gcloud sql instances list >> STATUS-CHECK-${TodayUTC}.txt

## PRD LGES
gcloud config set project pjt-hrcore-prd-lges
gcloud sql instances list >> STATUS-CHECK-${TodayUTC}.txt

$Runnable_Total = (Select-String -Path STATUS-CHECK-${TodayUTC}.txt -Pattern "RUNNABLE" -AllMatches).Matches.Count
$Instance_Total = (Select-String -Path STATUS-CHECK-${TodayUTC}.txt -Pattern "csql-" -AllMatches).Matches.Count

# -3는 앞에 echo 2건, HEADER line 1건 총 3건
if ( $Runnable_Total -eq $Instance_Total ) {
	echo "`nSUCCESS : All production instances are in RUNNABLE state`n" >> STATUS-CHECK-${TodayUTC}.txt
} else {
	echo "`nERROR : Some instances are in STOPPED state`n" >> STATUS-CHECK-${TodayUTC}.txt
}

cat STATUS-CHECK-${TodayUTC}.txt
