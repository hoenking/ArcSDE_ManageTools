

@echo off
echo ***************************************************************************
echo *                                                                         *
echo *      ============== ɽά�Ƽ�ARCSDE���ݿ��Ż�������=================     *
echo *                                     --create by wh                      *
echo *                                                                         *
echo *   �����б�:                                                             *
echo *           A. �ؽ����ݿ�����;                B. �ؽ�ͳ����Ϣ;            *
echo *           C. ѹ���汾��;                    D. �Ͽ�ȫ��SDE����;         *
echo ***************************************************************************
echo
echo *ע�⣺һ���ȶϿ�ȫ��SDE���ӣ���ִ���������ܣ��Ͽ����ӻ�Ӱ���������������
echo
set /p FUNC_NUM=��ѡ��Ҫִ�еĹ���(��ĸA-D)��

if /i "%FUNC_NUM%"=="A" goto section1
if /i "%FUNC_NUM%"=="B" goto section2
if /i "%FUNC_NUM%"=="C" goto section3
if /i "%FUNC_NUM%"=="D" goto section4

:main

echo ==���������ù���%PYFILENAME%�������==

set /p TNS_NAME=������Ŀ���� ���������:

set /p SYSTEM_PWD=�������û� SYSTEM ����:

set /p TABLESPACE=������Ŀ���� ��ռ���:

set /p PC_NAME=������������� IP��������:

set DATE=%date:~0,4%%date:~5,2%%date:~8,2%

echo conn SYSTEM/%SYSTEM_PWD%@%TNS_NAME% > %~dp0%bin\LetsMakeIt.SQL

echo set serveroutput on; >> %~dp0%bin\LetsMakeIt.SQL

echo set heading off ; >> %~dp0%bin\LetsMakeIt.SQL

echo spool %~dp0\log\BATREBINDEX_LOG%DATE%.txt >> %~dp0%bin\LetsMakeIt.SQL

echo delete from %TABLESPACE%.state_locks; >> %~dp0%bin\LetsMakeIt.SQL

echo delete from %TABLESPACE%.object_locks; >> %~dp0%bin\LetsMakeIt.SQL

echo delete from %TABLESPACE%.layer_locks; >> %~dp0%bin\LetsMakeIt.SQL

echo delete from %TABLESPACE%.table_locks; >> %~dp0%bin\LetsMakeIt.SQL

echo commit; >> %~dp0%bin\LetsMakeIt.SQL

echo spool off; >> %~dp0%bin\LetsMakeIt.SQL

echo set serveroutput off; >> %~dp0%bin\LetsMakeIt.SQL

echo set heading on; >> %~dp0%bin\LetsMakeIt.SQL

echo exit >> %~dp0%bin\LetsMakeIt.SQL

:kill
echo �ж��������ӵ�%TABLESPACE%��SDE����...

sdemon -o kill -t all -u %TABLESPACE% -p %TABLESPACE% -i sde:oracle11g:%TNS_NAME%:%TABLESPACE% -s %PC_NAME% -N

goto end

:run
if "%JustKill%"=="Y" goto kill

echo ����쳣�����������Ϣ...

sqlplus /nolog @"%~dp0%bin\LetsMakeIt.SQL"

echo ��ȷ��ArcGis��Python.exe��·���Ƿ�Ϊ C:\Python27\ArcGIS10.2\python.exe

set /p PYTHONPATH=����ǣ�������Y�������������ȷ��ַ��

if /i "%PYTHONPATH%"=="Y" set PYTHONPATH=C:\Python27\ArcGIS10.2\python.exe

echo ��ȷ�� bin Ŀ¼���Ƿ���ڴ��������ݿ���ȷ�� .sde �����ļ��������ڻ���������¿���֮���ټ�����

set /p input=���ؽ�%TABLESPACE%�Ŀռ��������Ƿ������Y/N��:

if /i "%input%"=="N" goto end

echo ����ͼ���ؽ�...

cd /d %~dp0\bin

%PYTHONPATH% %PYFILENAME%

goto end

:end
echo Complete!

pause

exit

:section1
set JustKill=N

set PYFILENAME=1_�ؽ�ͼ������.py

goto main

:section2
set JustKill=N

set PYFILENAME=2_�ؽ�ͳ����Ϣ.py

goto main

:section3
set JustKill=N

set PYFILENAME=3_�汾ѹ��.py

goto main

:section4
set JustKill=Y

goto main
