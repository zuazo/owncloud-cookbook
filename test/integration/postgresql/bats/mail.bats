#!/usr/bin/env bats

@test "owncloud should be able to send emails" {
  wget -qO/dev/null --keep-session-cookies --save-cookies /tmp/cookies.txt --post-data 'user=test&password=test' 'http://localhost/'
  TOKEN="$(wget -qO- --load-cookies /tmp/cookies.txt --keep-session-cookies --save-cookies /tmp/cookies.txt  'http://localhost/index.php/settings/personal' | grep data-requesttoken | sed 's/^.*data-requesttoken="\(.*\)".*$/\1/')"
  wget -qO/dev/null --header="requesttoken: ${TOKEN}" --load-cookies /tmp/cookies.txt --post-data 'email=root@localhost.localdomain' 'http://localhost/index.php/settings/ajax/lostpassword.php'
  wget -qO/dev/null --post-data 'user=test' 'http://localhost/index.php/lostpassword/'
  sleep 1
  if [ -f '/var/spool/mail/root' ]
  then
    MAIL_FILE='/var/spool/mail/root'
  else
    MAIL_FILE='/var/spool/mail/vagrant'
  fi
  grep -qF 'lostpassword-noreply@' "${MAIL_FILE}"
}
