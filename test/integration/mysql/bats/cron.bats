#!/usr/bin/env bats

@test "owncloud cron should be enabled" {
  crontab -l -u 'www-data' | grep -Fq "php -f '/var/www/owncloud/cron.php'"
}

