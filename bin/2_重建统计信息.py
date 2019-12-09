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

LogFile = pathname+"\\log\\" + Date + " " + Time1 + "-GISAnalyze.txt"
output = open(LogFile, "w")
output.write("GISAnalyze\n")
output.write(strmsg1)

for fileLine in workspacelist:
    ENV.workspace =fileLine.replace("\n","")
    strmsg1 = "Process Workspace: " + fileLine + "\n"
    print strmsg1
    output.write(strmsg1)
    try:
        FCList = arcpy.ListFeatureClasses("*", "Point;Arc;Region;Annotation")
        for FC in FCList:
            strmsg1 = "Process FeatureClass: " + FC.encode("gb2312") + "\n"
            print strmsg1
            output.write(strmsg1)
            arcpy.Analyze_management(FC, "BUSINESS")
            print arcpy.GetMessages().encode("gb2312") + "\n"
            output.write(arcpy.GetMessages().encode("gb2312")+ "\n")
            #arcpy.Analyze_management(FC, "FEATURE")
            #print arcpy.GetMessages().encode("gb2312") + "\n"
            #output.write(arcpy.GetMessages().encode("gb2312")+ "\n")
            arcpy.Analyze_management(FC, "ADDS")
            print arcpy.GetMessages().encode("gb2312") + "\n"
            output.write(arcpy.GetMessages().encode("gb2312")+ "\n")
            arcpy.Analyze_management(FC, "DELETES")
            print arcpy.GetMessages().encode("gb2312") + "\n"
            output.write(arcpy.GetMessages().encode("gb2312")+ "\n")
        DSList = arcpy.ListDatasets ("*", "all")
        for DS in DSList:
            strmsg1 = "Process Dataset: " + DS.encode("gb2312") + "\n"
            print strmsg1
            output.write(strmsg1)
            arcpy.Analyze_management(DS, "BUSINESS;FEATURE;ADDS;DELETES")
            print arcpy.GetMessages().encode("gb2312") + "\n"
            output.write(arcpy.GetMessages().encode("gb2312") + "\n")
    except:
        str1 = str(arcpy.GetMessages().encode("gb2312"))
        print str1
        output.write(str1 + "\n")

Date = time.strftime("%Y-%m-%d", time.localtime())
Time = time.strftime("%I:%M:%S %p", time.localtime())
output.write("Process completed at " + str(Date) + " " + str(Time) + "." + "\n")
output.close()
print "Process completed at " + str(Date) + " " + str(Time) + "."
