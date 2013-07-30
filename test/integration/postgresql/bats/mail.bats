#!/usr/bin/env bats

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
