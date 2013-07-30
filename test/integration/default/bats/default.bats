#!/usr/bin/env bats

@test "database should be created" {
  echo "show databases" | mysql -uroot -pvagrant_root | grep -q "^owncloud$"
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
  if [ -f '/var/spool/mail/vagrant' ]
  then
    MAIL_FILE='/var/spool/mail/vagrant'
  else
    MAIL_FILE='/var/mail/root'
  fi
  grep -qF 'lostpassword-noreply@' "${MAIL_FILE}"
}
