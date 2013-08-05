#!/usr/bin/env bats

@test "owncloud cron should be enabled" {
  if id www-data >/dev/null 2>&1
  then
    APACHE_USER='www-data'
  else
    APACHE_USER='apache'
  fi
  crontab -l -u "${APACHE_USER}" | grep -q "php -f '.*/owncloud/cron.php'"
}
