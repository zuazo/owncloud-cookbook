name             'owncloud'
maintainer       'Onddo Labs, Sl.'
maintainer_email 'team@onddo.com'
license          'Apache 2.0'
description      'Installs/Configures ownCloud'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.1'

supports 'centos'
supports 'debian'
supports 'ubuntu'

depends 'apache2'
depends 'apt'
depends 'database'
depends 'mysql'
depends 'nginx'
depends 'openssl'
depends 'php'
depends 'php-fpm', '>= 0.6.0'
depends 'postfix'
depends 'postgresql'

suggests 'git'

recipe 'owncloud::default', 'Installs and configures ownCloud'

attribute 'owncloud/version',
  :display_name => 'ownCloud Version',
  :description => 'Version of ownCloud to install',
  :type => 'string',
  :required => 'optional',
  :default => '"latest"'

attribute 'owncloud/download_url',
  :display_name => 'ownCloud Download Url',
  :description => 'Url from where ownCloud will be downloaded',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

attribute 'owncloud/deploy_from_git',
  :display_name => 'ownCloud Deploy From Git',
  :description => 'Whether ownCloud should be deployed from the git repository',
  :type => 'string',
  :required => 'optional',
  :default => 'false'

attribute 'owncloud/git_repo',
  :display_name => 'ownCloud Git Repo',
  :description => 'Url of the ownCloud git repository',
  :type => 'string',
  :required => 'optional',
  :default => '"https://github.com/owncloud/core.git"'

attribute 'owncloud/git_ref',
  :display_name => 'ownCloud Git Ref',
  :description => 'Git reference to deploy',
  :type => 'string',
  :required => 'optional',
  :default => 'nil'

attribute 'owncloud/www_dir',
  :display_name => 'ownCloud www Dir',
  :description => 'Root directory defined in Apache where web documents are stored',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

attribute 'owncloud/dir',
  :display_name => 'ownCloud Dir',
  :description => 'Directory where ownCloud will be installed',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

attribute 'owncloud/data_dir',
  :display_name => 'ownCloud Data Dir',
  :description => 'Directory where ownCloud data will be stored',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

attribute 'owncloud/server_name',
  :display_name => 'ownCloud Server Name',
  :description => 'Sets the server name for the ownCloud virtual host',
  :calculated => true,
  :type => 'string',
  :required => 'recommended'

attribute 'owncloud/server_aliases',
  :display_name => 'ownCloud Server Aliases',
  :description => 'Sets the server name aliases for the ownCloud virtual host',
  :type => 'array',
  :required => 'optional',
  :default => [ 'localhost' ]

attribute 'owncloud/install_postfix',
  :display_name => 'install Postfix?',
  :description => 'Whether to install Postfix when a local MTA is needed',
  :choice => [ 'true', 'false' ],
  :type => 'string',
  :required => 'optional',
  :default => 'true'

attribute 'owncloud/web_server',
  :display_name => 'Web Server',
  :description => 'Web server to use: apache or nginx',
  :choice => [ 'apache', 'nginx' ],
  :type => 'string',
  :required => 'optional',
  :default => 'apache'

attribute 'owncloud/php-fpm/pool',
  :display_name => 'PHP-FPM pool',
  :description => 'PHP-FPM pool name to use with ownCloud',
  :type => 'string',
  :required => 'optional',
  :default => '"owncloud"'

attribute 'owncloud/max_upload_size',
  :display_name => 'Max Upload Size',
  :description => 'Maximum allowed size for uploaded files',
  :type => 'string',
  :required => 'optional',
  :default => '"512M"'

attribute 'owncloud/ssl',
  :display_name => 'ownCloud Use SSL?',
  :description => 'Whether ownCloud should accept requests through SSL',
  :choice => [ 'true', 'false' ],
  :type => 'string',
  :required => 'optional',
  :default => 'true'

attribute 'owncloud/ssl_key_dir',
  :display_name => 'SSL key directory',
  :description => 'The directory to save the generated private SSL key',
  :type => 'string',
  :required => 'optional',
  :calculated => true

attribute 'owncloud/ssl_cert_dir',
  :display_name => 'SSL certificate directory',
  :description => 'The directory path to save the generated public SSL certificate',
  :type => 'string',
  :required => 'optional',
  :calculated => true

attribute 'owncloud/admin/user',
  :display_name => 'ownCloud Admin Username',
  :description => 'Administrator username',
  :type => 'string',
  :required => 'optional',
  :default => '"admin"'

attribute 'owncloud/admin/pass',
  :display_name => 'ownCloud Admin Password',
  :description => 'Administrator password',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

attribute 'owncloud/config/dbtype',
  :display_name => 'ownCloud Database Type',
  :description => 'Type of database, can be sqlite, mysql or pgsql',
  :choice => [ '"mysql"', '"pgsql"', '"sqlite"' ],
  :type => 'string',
  :required => 'optional',
  :default => '"mysql"'

attribute 'owncloud/config/dbname',
  :display_name => 'ownCloud Database Name',
  :description => 'Name of the ownCloud database',
  :type => 'string',
  :required => 'optional',
  :default => '"owncloud"'

attribute 'owncloud/config/dbuser',
  :display_name => 'ownCloud Database User',
  :description => 'User to access the ownCloud database',
  :type => 'string',
  :required => 'optional',
  :default => '"owncloud"'

attribute 'owncloud/config/dbpassword',
  :display_name => 'ownCloud Database Password',
  :description => 'Password to access the ownCloud database',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

attribute 'owncloud/config/dbhost',
  :display_name => 'ownCloud Database Host',
  :description => 'Host running the ownCloud database',
  :type => 'string',
  :required => 'optional',
  :default => '"localhost"'

attribute 'owncloud/config/dbtableprefix',
  :display_name => 'ownCloud Database Table Prefix',
  :description => 'Prefix for the ownCloud tables in the database',
  :type => 'string',
  :required => 'optional',
  :default => '""'

attribute 'owncloud/config/mail_smtpmode',
  :display_name => 'ownCloud Mail SMTP Mode',
  :description => 'Mode to use for sending mail, can be sendmail, smtp, qmail or php',
  :choice => [ '"sendmail"', '"smtp"', '"qmail"', '"php"' ],
  :type => 'string',
  :required => 'optional',
  :default => '"sendmail"'

attribute 'owncloud/config/mail_smtphost',
  :display_name => 'ownCloud Mail SMTP Host',
  :description => 'Host to use for sending mail, depends on mail_smtpmode if this is used',
  :type => 'string',
  :required => 'optional',
  :default => '"127.0.0.1"'

attribute 'owncloud/config/mail_smtpport',
  :display_name => 'ownCloud Mail SMTP Port',
  :description => 'Port to use for sending mail, depends on mail_smtpmode if this is used',
  :type => 'string',
  :required => 'optional',
  :default => '25'

attribute 'owncloud/config/mail_smtptimeout',
  :display_name => 'ownCloud Mail SMTP Timeout',
  :description => 'SMTP server timeout in seconds for sending mail, depends on mail_smtpmode if this is used',
  :type => 'string',
  :required => 'optional',
  :default => '10'

attribute 'owncloud/config/mail_smtpsecure',
  :display_name => 'ownCloud Mail SMTP Secure',
  :description => 'SMTP connection prefix or sending mail, depends on mail_smtpmode if this is used. Can be "", ssl or tls',
  :choice => [ '""', '"ssl"', '"tls"' ],
  :type => 'string',
  :required => 'optional',
  :default => '""'

attribute 'owncloud/config/mail_smtpauth',
  :display_name => 'ownCloud Mail SMTP Auth',
  :description => 'Whether authentication is needed to send mail, depends on mail_smtpmode if this is used',
  :choice => [ 'true', 'false' ],
  :type => 'string',
  :required => 'optional',
  :default => 'false'

attribute 'owncloud/config/mail_smtpauthtype',
  :display_name => 'ownCloud Mail SMTP Auth Type',
  :description => 'authentication type needed to send mail, depends on mail_smtpmode if this is used. Can be LOGIN, PLAIN or NTLM',
  :choice => [ '"LOGIN"', '"PLAIN"', '"NTLM"' ],
  :type => 'string',
  :required => 'optional',
  :default => '"LOGIN"'

attribute 'owncloud/config/mail_smtpname',
  :display_name => 'ownCloud Mail SMTP Name',
  :description => 'Username to use for sendmail mail, depends on mail_smtpauth if this is used',
  :type => 'string',
  :required => 'optional',
  :default => '""'

attribute 'owncloud/config/mail_smtppassword',
  :display_name => 'ownCloud Mail SMTP Password',
  :description => 'Password to use for sendmail mail, depends on mail_smtpauth if this is used',
  :type => 'string',
  :required => 'optional',
  :default => '""'

attribute 'owncloud/cron/enabled',
  :display_name => 'ownCloud cron enabled',
  :description => 'Whether to enable ownCloud cron',
  :type => 'string',
  :required => 'optional',
  :default => 'true'

attribute 'owncloud/cron/min',
  :display_name => 'ownCloud cron minute',
  :description => 'Minute to run ownCloud cron at',
  :type => 'string',
  :required => 'optional',
  :default => '"*/15"'

attribute 'owncloud/cron/hour',
  :display_name => 'ownCloud cron hour',
  :description => 'Hour to run ownCloud cron at',
  :type => 'string',
  :required => 'optional',
  :default => '"*"'

attribute 'owncloud/cron/day',
  :display_name => 'ownCloud cron day',
  :description => 'Day of month to run ownCloud cron at',
  :type => 'string',
  :required => 'optional',
  :default => '"*"'

attribute 'owncloud/cron/month',
  :display_name => 'ownCloud cron month',
  :description => 'Month to run ownCloud cron at',
  :type => 'string',
  :required => 'optional',
  :default => '"*"'

attribute 'owncloud/cron/weekday',
  :display_name => 'ownCloud cron weekday',
  :description => 'Weekday to run ownCloud cron at',
  :type => 'string',
  :required => 'optional',
  :default => '"*"'
