#!/usr/bin/env bats

@test "owncloud should be able to send emails" {
  wget -qO/dev/null 'http://localhost/emailtest.php'
  sleep 1
  if [ -f '/var/spool/mail/root' ]
  then
    MAIL_FILE='/var/spool/mail/root'
  else
    MAIL_FILE='/var/spool/mail/vagrant'
  fi
  grep -qF 'kitchen-test@' "${MAIL_FILE}"
}
