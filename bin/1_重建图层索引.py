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

LogFile = pathname+"\\log\\" + Date + " " + Time1 + "-GISRebuildIndex.txt"
output = open(LogFile, "w")
output.write("RebuildIndex\n")
output.write(strmsg1)

for fileLine in workspacelist:
    ENV.workspace =fileLine.replace("\n","")
    strmsg1 = "Process Workspace: " + fileLine + "\n"
    print strmsg1
    output.write(strmsg1)
    try:
        FCList = arcpy.ListFeatureClasses("*", "all")
        for FC in FCList:
	    	strmsg1 = "Process FeatureClass: " + FC.encode("gb2312") + "\n"
	    	print strmsg1
	    	output.write(strmsg1)
	    	arcpy.AddSpatialIndex_management(FC,"0","0","0")
	    	str1 = str(arcpy.GetMessages().encode("gb2312"))
	    	output.write(str1 + "\n")
        print "before"
        datasets = arcpy.ListDatasets("*", "all")
        print datasets
        for ds in datasets:
                strmsg1 = "Process Dataset: " + ds.encode("gb2312") + "\n"		
	    	print strmsg1		
         	output.write(strmsg1)		
                for FC in arcpy.ListFeatureClasses("*", "all", ds):
	    	    strmsg1 = "Process FeatureClass: " + FC.encode("gb2312") + "\n"
	    	    print strmsg1
	    	    output.write(strmsg1)
	    	    arcpy.AddSpatialIndex_management(FC,"0","0","0")
	    	    str1 = str(arcpy.GetMessages().encode("gb2312"))
	    	    output.write(str1 + "\n")

    except:
        str1 = str(arcpy.GetMessages().encode("gb2312"))
        output.write(str1 + "\n")

Date = time.strftime("%Y-%m-%d", time.localtime())
Time = time.strftime("%I:%M:%S %p", time.localtime())
output.write("Process completed at " + str(Date) + " " + str(Time) + "." + "\n")
output.close()
print "Process completed at " + str(Date) + " " + str(Time) + "."
