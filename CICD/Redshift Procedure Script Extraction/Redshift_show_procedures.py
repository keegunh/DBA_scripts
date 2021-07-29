#파일 경로는 절대경로로 사용할 것.

import datetime
f_read = open("0-Redshift_procedures_to_deploy.txt", 'r')


now = datetime.datetime.now()
formattedDate = now.strftime("%Y%m%d")
#formattedDate = now.strftime("%Y%m%d_%H%M%S")

f_write = open("1-Redshift_show_procedures_"+ formattedDate +".sql", 'w')

lines = f_read.readlines()
for line in lines:
    #print("show procedure public." + line + ";")
    f_write.write("show procedure public." + line + ";")

f_read.close()
f_write.close()
