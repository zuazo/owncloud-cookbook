#!/usr/bin/env bats

@test "nginx should be listening" {
  wget --server-response --no-check-certificate -O- 'https://localhost' 2>&1 > /dev/null | grep -q '^\s*Server: nginx'
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
