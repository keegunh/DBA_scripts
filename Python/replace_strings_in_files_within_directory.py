import os
import datetime
import shutil

now = datetime.datetime.now()
formattedDate = now.strftime("%Y-%m-%d %H:%M:%S")
print("start time : " + formattedDate)

os.chdir("C:\\폴더경로"")
#os.chdir("D:\\keegunh\\Desktop\\SQL scripts\\PMPBADM_DDL\\PARTITION TABLES\\sub_partition_table") ## 경로 예시


files = os.listdir()

if "modified" not in files:
    os.mkdir("modified")

fnum = 0
for filename in files:
    ext = os.path.splitext(filename)[-1]
    if ext == '.sql': ## 파일 확장자 지정
        fnum += 1
        print("[" + str(fnum) + "] WORKING ON FILENAME : " + filename)

        f_read = open(filename, 'r')
        f_write = open(newFileName, 'w')

        lines = f_read.readlines()
        lnum = 0
        for line in lines:
            lnum += 1
            
            line = line.replace("STRING A", "STRING B")

""" ## REPLACE 예시 ##
            if "TB_ST" in tableName:
                if "tablespace TS_NUPB_D01 PARALLEL 16 NOLOGGING;" in line:
                    line = line.replace("tablespace TS_NUPB_D01 PARALLEL 16 NOLOGGING;","tablespace TS_ST_IP01 PARALLEL 16 NOLOGGING;")

                if "TS_NUPB_D01" in line:
                    line = line.replace("TS_NUPB_D01","TS_ST_DP01")

            if "TB_ST" not in tableName:
                if "tablespace TS_NUPB_D01 PARALLEL 16 NOLOGGING;" in line:
                    line = line.replace("tablespace TS_NUPB_D01 PARALLEL 16 NOLOGGING;","tablespace TS_PMPB_IP01 PARALLEL 16 NOLOGGING;")

                if "TS_NUPB_D01" in line:
                    line = line.replace("TS_NUPB_D01","TS_PMPB_DP01")

            if all(x in line for x in ["GRANT","RL_NUPB_ALL"]):
                line = line.replace("RL_NUPB_ALL","RL_PMPB_ALL")

            if "\'가입신청번호\'" in line:
                line = line.replace("\'가입신청번호\'", "\'가입신청ID\'")

            f_write.write(line)
"""            

        f_read.close()
        f_write.close()

now = datetime.datetime.now()
formattedDate = now.strftime("%Y-%m-%d %H:%M:%S")
print("end time : " + formattedDate)