#!/usr/bin/env bats

@test "database should be created" {
  test -e /var/www/owncloud/data/owncloud.db  || \
    test -e /var/www/html/owncloud/data/owncloud.db
}

@test "owncloud should be installed" {
  wget -qO- 'localhost/status.php' | grep -qF '"installed":"true"'
}

@test "ssl should be enabled" {
  wget --no-check-certificate -qO- 'https://localhost'
}

@test "admin user should be created" {
  wget -qO- 'http://test:test@localhost/ocs/v1.php/privatedata/getattribute' | grep -qF '<status>ok</status>'
}

@test "owncloud should be able to send emails" {
  wget -qO/dev/null --post-data 'value=root@localhost.localdomain' 'http://test:test@localhost/ocs/v1.php/privatedata/setattribute/settings/email'
  wget -qO/dev/null --post-data 'user=test' 'http://localhost/index.php/lostpassword/'
  sleep 1
  grep -qF 'lostpassword-noreply@' /var/mail/root
}
