# GCP Logging 서비스에서 로그 파일을 JSON 파일로 다운 받은 후 
# 원하는 key-value만 추출하는 스크립트

$timeNow = Get-Date
$timeFormatted = $TimeNow.ToString("yyyyMMddHHmmss")

# 경로 및 파일명 설정
$inDir="C:\Users\80517\Downloads"				# JSON 파일 경로
$jsonFile="downloaded-logs-20220730-095829"		# JSON 파일명
$outDir="D:\2022 공통업무 상향 평준화 HR Core 프로젝트\스크립트\dba_private\GCP Cloud Shell\ConvertFrom-Json"	# 결과 파일 경로
$resultFile="result_${timeFormatted}.sql"															# 결과 파일명

echo "input json file : " ${inDir}\${jsonFile}.json
$json = (Get-Content ${inDir}\${jsonFile}.json -Raw) | ConvertFrom-Json
$json.psobject.Properties.Value.textPayload > ${outDir}\${resultFile}				## textPayload는 추출하고 싶은 Key명. 이거 변경하면 다른 Key도 추출 가능.
echo "output result file : " ${outDir}\${resultFile}.json