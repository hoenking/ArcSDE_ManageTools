conn SYSTEM/orcl@orcl_l 
set serveroutput on; 
set heading off ; 
spool E:\技巧资料\Oracle数据库\ArcSDE自动优化_ArcGISTASK\ArcSDE数据库优化工具箱\\log\BATREBINDEX_LOG20191209.txt 
delete from DXT500.state_locks; 
delete from DXT500.object_locks; 
delete from DXT500.layer_locks; 
delete from DXT500.table_locks; 
commit; 
spool off; 
set serveroutput off; 
set heading on; 
exit 
