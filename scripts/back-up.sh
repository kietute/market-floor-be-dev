
BACKUP_FILE="market-floor-backup.sql"

export $(cat ../.env.development | xargs)

echo "Start backing up data for: $PROJECT_DB_NAME"

pg_dump -U $PROJECT_DB_USER -h localhost -Fp --no-owner --no-privileges $PROJECT_DB_NAME > $BACKUP_FILE

echo "Backing up data complete: $BACKUP_FILE"
