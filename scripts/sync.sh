#!/bin/bash

export $(cat ../.env.development | xargs)

BACKUP_FILE="market-floor-backup.sql"
DB_EXIST=$(psql -U $PROJECT_DB_USER -h localhost -lqt | cut -d \| -f 1 | grep -w $PROJECT_DB_NAME)

if [ -z "$DB_EXIST" ]; then
    echo "Database $PROJECT_DB_NAME does not exist. Creating the database..."
    createdb -U $PROJECT_DB_USER -h localhost $PROJECT_DB_NAME
    echo "Database $PROJECT_DB_NAME has been created successfully."
else
    echo "Database $PROJECT_DB_NAME already exists. Dropping and recreating..."

    # Terminate all connections to the database
    echo "Terminating active connections to $PROJECT_DB_NAME..."
    psql -U $PROJECT_DB_USER -h localhost -d postgres -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$PROJECT_DB_NAME' AND pid <> pg_backend_pid();"

    # Drop the existing database
    dropdb -U $PROJECT_DB_USER -h localhost $PROJECT_DB_NAME
    
    # Recreate the database
    createdb -U $PROJECT_DB_USER -h localhost $PROJECT_DB_NAME
    
    echo "Database $PROJECT_DB_NAME has been recreated."
fi

echo "Start syncing data from backup file: $BACKUP_FILE"

psql -U $PROJECT_DB_USER -h $PROJECT_DB_HOST $PROJECT_DB_NAME < $BACKUP_FILE

echo "Data sync completed from file: $BACKUP_FILE"
