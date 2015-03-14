#!/usr/bin/env bats

@test "database should be created" {
  test -e /var/www/owncloud/data/owncloud.db  || \
    test -e /var/www/html/owncloud/data/owncloud.db
}

@test "owncloud should be installed" {
  wget -qO- 'localhost/status.php' | grep -qE '"installed":"?true"?'
}

@test "ssl should be enabled" {
  wget --no-check-certificate -qO- 'https://localhost'
}

@test "admin user should be created" {
  wget -qO- 'http://test:test@localhost/ocs/v1.php/privatedata/getattribute' | grep -qF '<status>ok</status>'
}
