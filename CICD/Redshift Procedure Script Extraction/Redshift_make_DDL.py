#파일 경로는 절대경로로 사용할 것.

import datetime

now = datetime.datetime.now()
formattedDate = now.strftime("%Y%m%d")
#formattedDate = now.strftime("%Y%m%d_%H%M%S")

f_read = open("2-Redshift_deploy_" + formattedDate + ".sql", 'r', encoding="UTF-8")
f_write = open("3-Redshift_deploy_final_"+ formattedDate +".sql", 'w')

lines = f_read.readlines()
dollar = 0
grantStr = []
for line in lines:
    line = line.rstrip('\n')      # 줄 끝에 '\n' 제거
    line = line.rstrip('+')       # 줄 끝에 '+' 제거
    line = line.replace('\\r','') # \r 제거
    line = line.rstrip()          # 우측에 남은 공백 제거
    if "------------------------------------------------------------------------------------------------------------------------------------------------------" in line:
        line = ''                 # ------------------------ 제거
    if line.find("(1 row)") == 0:
        line = ''                 # (1 row) 제거
    if "Stored Procedure Definition" in line:
        line = ''                 # Stored Procedure Definition 제거
    if "$$" in line:
        dollar += 1
        if dollar % 2 == 0:
            line = line + ';'     # 두번째 $$마다 ; 추가
    if "CREATE OR REPLACE" in line:
        grantStr.append(line)

    #print(line) #DEBUG
    f_write.write(line)
    f_write.write('\n')


# 파일 끝에 grant 문 추가
for line in grantStr:
    line = line.replace("CREATE OR REPLACE", "GRANT EXECUTE ON ")
    line = line + " TO granted_user;\n"
    #print(line) # DEBUG
    f_write.write(line)
    



f_read.close()
f_write.close()
