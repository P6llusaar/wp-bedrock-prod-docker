#!/usr/bin/env bash
set -Eeuo pipefail

chown -R www-data:www-data /var/www/html/bedrock/web/app/uploads 

#starts apache
exec "$@"