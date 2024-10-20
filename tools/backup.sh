#!/usr/bin/env bash

set -e

zip_filename=$(date +"%Y-%m-%d_%H%M%S_backup.zip")

#changing dir to the current script folder
cd "$(dirname "${BASH_SOURCE[0]}")"

docker compose exec -u wpadmin -T bedrock-blue bash -c \
    "cd /var/www/html/bedrock/web && wp db export  /backup_temp/backup.sql"

docker compose cp bedrock-blue:/backup_temp/backup.sql backup_temp/
docker compose exec bedrock-blue rm /backup_temp/backup.sql
docker compose cp  bedrock-blue:/var/www/html/bedrock/web/app/uploads backup_temp/
cp ../.env backup_temp/.env

cd backup_temp
zip -r "../backups/${zip_filename}" .


rm -rf ./*
rm -rf ./.env


