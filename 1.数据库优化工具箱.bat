

@echo off
echo ***************************************************************************
echo *                                                                         *
echo *      ============== 山维科技ARCSDE数据库优化工具箱=================     *
echo *                                     --create by wh                      *
echo *                                                                         *
echo *   功能列表:                                                             *
echo *           A. 重建数据库索引;                B. 重建统计信息;            *
echo *           C. 压缩版本库;                    D. 断开全部SDE连接;         *
echo ***************************************************************************
echo
echo *注意：一般先断开全部SDE连接，再执行其他功能（断开连接会影响所有连库操作）
echo
set /p FUNC_NUM=请选择要执行的功能(字母A-D)：

if /i "%FUNC_NUM%"=="A" goto section1
if /i "%FUNC_NUM%"=="B" goto section2
if /i "%FUNC_NUM%"=="C" goto section3
if /i "%FUNC_NUM%"=="D" goto section4

:main

echo ==请依次设置功能%PYFILENAME%所需参数==

set /p TNS_NAME=请输入目标库的 网络服务名:

set /p SYSTEM_PWD=请输入用户 SYSTEM 密码:

set /p TABLESPACE=请输入目标库的 表空间名:

set /p PC_NAME=请输入服务器的 IP或计算机名:

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
echo 中断所有连接到%TABLESPACE%的SDE连接...

sdemon -o kill -t all -u %TABLESPACE% -p %TABLESPACE% -i sde:oracle11g:%TNS_NAME%:%TABLESPACE% -s %PC_NAME% -N

goto end

:run
if "%JustKill%"=="Y" goto kill

echo 清除异常引起的锁定信息...

sqlplus /nolog @"%~dp0%bin\LetsMakeIt.SQL"

echo 请确认ArcGis中Python.exe的路径是否为 C:\Python27\ArcGIS10.2\python.exe

set /p PYTHONPATH=如果是，请输入Y，否则请输出正确地址：

if /i "%PYTHONPATH%"=="Y" set PYTHONPATH=C:\Python27\ArcGIS10.2\python.exe

echo 请确认 bin 目录下是否存在待处理数据库正确的 .sde 连接文件，不存在或错误请重新拷贝之后再继续！

set /p input=将重建%TABLESPACE%的空间索引！是否继续（Y/N）:

if /i "%input%"=="N" goto end

echo 索引图层重建...

cd /d %~dp0\bin

%PYTHONPATH% %PYFILENAME%

goto end

:end
echo Complete!

pause

exit

:section1
set JustKill=N

set PYFILENAME=1_重建图层索引.py

goto main

:section2
set JustKill=N

set PYFILENAME=2_重建统计信息.py

goto main

:section3
set JustKill=N

set PYFILENAME=3_版本压缩.py

goto main

:section4
set JustKill=Y

goto main
