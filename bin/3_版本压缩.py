import os
import fnmatch
import inspect
import re
import string
import time
import sys
import arcpy
import inspect

from arcpy import env as ENV

Date = time.strftime("%Y-%m-%d", time.localtime())
Time = time.strftime("%I:%M:%S %p", time.localtime())
Time1 = time.strftime("%I-%M-%S", time.localtime())
strmsg1 = "Process started at " + str(Date) + " " + str(Time) + "." + "\n"
print strmsg1

workspacelist = []
caller_file = inspect.getfile(inspect.currentframe())
pathname = os.path.abspath(os.path.dirname(caller_file))

for fileName in os.listdir ( pathname ):
   if fnmatch.fnmatch(fileName, '*.sde'):
       workspacelist.append(fileName)
if os.path.exists(pathname+"\log")==False:
   os.mkdir(pathname+"\log")
LogFile = pathname + "\\log\\" + Date + " " + Time1 + "-GISCompress.txt"
output = open(LogFile, "w")
output.write("GISCompress\n")
output.write(strmsg1)

for fileLine in workspacelist:
    ENV.workspace = fileLine
    strmsg1 = "Compress Workspace: " + fileLine + "\n"
    print strmsg1
    output.write(strmsg1)
    try:
       versionList = arcpy.ListVersions(fileLine)
       for version in versionList:
           if version.find("{")>-1:
		       print "Delete Version: " + version
		       arcpy.DeleteVersion_management(fileLine, version)
		       print arcpy.GetMessages().encode("gb2312") + "\n"
		       output.write(arcpy.GetMessages().encode("gb2312")+ "\n")

       arcpy.Compress_management(fileLine)
       print arcpy.GetMessages().encode("gb2312") + "\n"
       output.write(arcpy.GetMessages().encode("gb2312")+ "\n")
    except:
       print arcpy.GetMessages().encode("gb2312") + "\n"
       output.write(arcpy.GetMessages().encode("gb2312")+ "\n")

Date = time.strftime("%m-%d-%Y", time.localtime())# Set the date.
Time = time.strftime("%I:%M:%S %p", time.localtime()) # Set the time.
output.write(str("Process completed at " + str(Date) + " " + str(Time) + "." + "\n")) # Write the start time to the log file.
output.close() # Closes the log file.
print "Process completed at " + str(Date) + " " + str(Time) + "."
