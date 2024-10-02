$envVars = Get-Content "../.env.development"
foreach ($var in $envVars) {
    $name, $value = $var -split '='
    [System.Environment]::SetEnvironmentVariable($name, $value)
}

$BACKUP_FILE = "market-floor-backup.sql"
$PROJECT_DB_USER = $env:PROJECT_DB_USER
$PROJECT_DB_NAME = $env:PROJECT_DB_NAME


$DB_EXIST = psql -U $PROJECT_DB_USER -h localhost -lqt | Select-String -Pattern $PROJECT_DB_NAME

if (-not $DB_EXIST) {
    Write-Host "Database $PROJECT_DB_NAME does not exist. Creating the database..."
    createdb -U $PROJECT_DB_USER -h localhost $PROJECT_DB_NAME
    Write-Host "Database $PROJECT_DB_NAME has been created successfully."
} else {
    Write-Host "Database $PROJECT_DB_NAME already exists. Dropping and recreating..."

 
    Write-Host "Terminating active connections to $PROJECT_DB_NAME..."
    psql -U $PROJECT_DB_USER -h localhost -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$PROJECT_DB_NAME' AND pid <> pg_backend_pid();"

 
    dropdb -U $PROJECT_DB_USER -h localhost $PROJECT_DB_NAME
    

    createdb -U $PROJECT_DB_USER -h localhost $PROJECT_DB_NAME
    
    Write-Host "Database $PROJECT_DB_NAME has been recreated."
}

Write-Host "Start syncing data from backup file: $BACKUP_FILE"


psql -U $PROJECT_DB_USER -h localhost $PROJECT_DB_NAME < $BACKUP_FILE

Write-Host "Data sync completed from file: $BACKUP_FILE"
