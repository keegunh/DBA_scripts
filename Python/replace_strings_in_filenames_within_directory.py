import os
import datetime
import shutil

now = datetime.datetime.now()
formattedDate = now.strftime("%Y-%m-%d %H:%M:%S")
print("start time : " + formattedDate)



directory = "V:\개인폴더\신윤이\DBA공유\05.운영DB구성\05.기타object_ddl\01.view"
#os.chdir(directory)
files = os.listdir(directory)
if "renamed" not in files:
    os.mkdir(directory + "\renamed")

fnum = 0
for filename in files:
    ext = os.path.splitext(filename)[-1]
    if ext == '.sql':
        fnum += 1
        print("[" + str(fnum) + "] WORKING ON FILENAME : " + filename)
        
        old_name = os.path.join(directory, filename)
        new_name = os.path.join(directory + "\renamed", filename.replace("VIEW - ", ""))
        
        shutil.copy(old_name, new_name)
        # os.rename(old_name, new_name)

now = datetime.datetime.now()
formattedDate = now.strftime("%Y-%m-%d %H:%M:%S")
print("end time : " + formattedDate)