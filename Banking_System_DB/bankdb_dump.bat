@ECHO OFF
set TIMESTAMP=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%

"C:\Program Files\MySQL\MySQL Workbench 6.3 CE\mysqldump.exe"  --all-databases --result-file="S:\NEU\NEU_Notes\DBMS\VaibhaviKamani_001825058\Backup\%TIMESTAMP%_bankdb_dump.sql" --user=Manager --password=man 

pause
exit