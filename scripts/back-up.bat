@echo off
set BACKUP_FILE=market-floor-backup.sql

for /f "usebackq tokens=*" %%i in (..\env.development) do set %%i

echo Start backing up data for: %PROJECT_DB_NAME%

pg_dump -U %PROJECT_DB_USER% -h localhost -Fp --no-owner --no-privileges %PROJECT_DB_NAME% > %BACKUP_FILE%

echo Backing up data complete: %BACKUP_FILE%
