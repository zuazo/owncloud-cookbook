# encoding: UTF-8
#
# Cookbook Name:: owncloud
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Xabier de Zuazo
# Copyright:: Copyright (c) 2013-2015 Onddo Labs, SL.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name 'owncloud'
maintainer 'Xabier de Zuazo'
maintainer_email 'xabier@zuazo.org'
license 'Apache 2.0'
description <<-EOH
Installs and configures ownCloud, an open source personal cloud for data and
file sync, share and view.
EOH
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.0.0'

if respond_to?(:source_url)
  source_url "https://github.com/zuazo/#{name}-cookbook"
end
if respond_to?(:issues_url)
  issues_url "https://github.com/zuazo/#{name}-cookbook/issues"
end

supports 'centos'
supports 'debian'
supports 'scientific'
supports 'ubuntu'

depends 'apache2', '~> 3.0'
depends 'apt', '~> 2.0'
depends 'cron', '~> 1.6'
depends 'database', '~> 4.0'
depends 'encrypted_attributes', '~> 0.2'
depends 'mysql2_chef_gem', '~> 1.0.1'
depends 'mysql', '~> 6.0'
depends 'nginx', '~> 2.7'
depends 'openssl', '~> 4.0'
depends 'php', '~> 1.4'
depends 'php-fpm', '~> 0.7'
depends 'postfix', '~> 3.0'
depends 'postgresql', '~> 3.4.18'
depends 'ssl_certificate', '~> 1.1'

recipe 'owncloud::default', 'Installs and configures ownCloud'

attribute 'owncloud/version',
          display_name: 'ownCloud Version',
          description: 'Version of ownCloud to install',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/download_url',
          display_name: 'ownCloud Download Url',
          description: 'Url from where ownCloud will be downloaded',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/deploy_from_git',
          display_name: 'ownCloud Deploy From Git',
          description:
            'Whether ownCloud should be deployed from the git repository',
          type: 'string',
          required: 'optional',
          default: 'false'

attribute 'owncloud/git_repo',
          display_name: 'ownCloud Git Repo',
          description: 'Url of the ownCloud git repository',
          type: 'string',
          required: 'optional',
          default: 'https://github.com/owncloud/core.git'

attribute 'owncloud/git_ref',
          display_name: 'ownCloud Git Ref',
          description: 'Git reference to deploy',
          type: 'string',
          required: 'optional',
          default: 'nil'

attribute 'owncloud/www_dir',
          display_name: 'ownCloud www Dir',
          description:
            'Root directory defined in Apache where web documents are stored',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/dir',
          display_name: 'ownCloud Dir',
          description: 'Directory where ownCloud will be installed',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/data_dir',
          display_name: 'ownCloud Data Dir',
          description: 'Directory where ownCloud data will be stored',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/server_name',
          display_name: 'ownCloud Server Name',
          description: 'Sets the server name for the ownCloud virtual host',
          calculated: true,
          type: 'string',
          required: 'recommended'

attribute 'owncloud/server_aliases',
          display_name: 'ownCloud Server Aliases',
          description:
            'Sets the server name aliases for the ownCloud virtual host',
          type: 'array',
          required: 'optional',
          default: []

attribute 'owncloud/install_postfix',
          display_name: 'install Postfix?',
          description: 'Whether to install Postfix when a local MTA is needed',
          choice: %w(true false),
          type: 'string',
          required: 'optional',
          default: 'true'

attribute 'owncloud/web_server',
          display_name: 'Web Server',
          description: 'Web server to use: apache or nginx',
          choice: %w(apache nginx),
          type: 'string',
          required: 'optional',
          default: 'apache'

attribute 'owncloud/php-fpm/pool',
          display_name: 'PHP-FPM pool',
          description: 'PHP-FPM pool name to use with ownCloud',
          type: 'string',
          required: 'optional',
          default: 'owncloud'

attribute 'owncloud/max_upload_size',
          display_name: 'Max Upload Size',
          description: 'Maximum allowed size for uploaded files',
          type: 'string',
          required: 'optional',
          default: '512M'

attribute 'owncloud/sendfile',
          display_name: 'Sendfile',
          description:
            'Whether to enable Sendfile on web server. You should set to '\
            'false if you use NFS or SMB mounts',
          choice: %w(true false),
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/ssl',
          display_name: 'ownCloud Use SSL?',
          description: 'Whether ownCloud should accept requests through SSL',
          choice: %w(true false),
          type: 'string',
          required: 'optional',
          default: 'true'

attribute 'owncloud/admin/user',
          display_name: 'ownCloud Admin Username',
          description: 'Administrator username',
          type: 'string',
          required: 'optional',
          default: 'admin'

attribute 'owncloud/admin/pass',
          display_name: 'ownCloud Admin Password',
          description: 'Administrator password',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/config/dbtype',
          display_name: 'ownCloud Database Type',
          description: 'Type of database, can be sqlite, mysql or pgsql',
          choice: %w(mysql pgsql sqlite),
          type: 'string',
          required: 'optional',
          default: 'mysql'

attribute 'owncloud/config/dbname',
          display_name: 'ownCloud Database Name',
          description: 'Name of the ownCloud database',
          type: 'string',
          required: 'optional',
          default: 'owncloud'

attribute 'owncloud/config/dbuser',
          display_name: 'ownCloud Database User',
          description: 'User to access the ownCloud database',
          type: 'string',
          required: 'optional',
          default: 'owncloud'

attribute 'owncloud/config/dbpassword',
          display_name: 'ownCloud Database Password',
          description: 'Password to access the ownCloud database',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/config/dbhost',
          display_name: 'ownCloud Database Host',
          description: 'Host running the ownCloud database',
          type: 'string',
          required: 'optional',
          default: '127.0.0.1'

attribute 'owncloud/config/dbport',
          display_name: 'ownCloud Database Port',
          description: 'Port the ownCloud database is running at',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/config/dbtableprefix',
          display_name: 'ownCloud Database Table Prefix',
          description: 'Prefix for the ownCloud tables in the database',
          type: 'string',
          required: 'optional',
          default: ''

attribute 'owncloud/config/mail_smtpmode',
          display_name: 'ownCloud Mail SMTP Mode',
          description:
            'Mode to use for sending mail, can be sendmail, smtp, qmail or php',
          choice: %w(sendmail smtp qmail php),
          type: 'string',
          required: 'optional',
          default: 'sendmail'

attribute 'owncloud/config/mail_smtphost',
          display_name: 'ownCloud Mail SMTP Host',
          description:
            'Host to use for sending mail, depends on mail_smtpmode if this '\
            'is used',
          type: 'string',
          required: 'optional',
          default: '127.0.0.1'

attribute 'owncloud/config/mail_smtpport',
          display_name: 'ownCloud Mail SMTP Port',
          description:
            'Port to use for sending mail, depends on mail_smtpmode if this '\
            'is used',
          type: 'string',
          required: 'optional',
          default: '25'

attribute 'owncloud/config/mail_smtptimeout',
          display_name: 'ownCloud Mail SMTP Timeout',
          description:
            'SMTP server timeout in seconds for sending mail, depends on '\
            'mail_smtpmode if this is used',
          type: 'string',
          required: 'optional',
          default: '10'

attribute 'owncloud/config/mail_smtpsecure',
          display_name: 'ownCloud Mail SMTP Secure',
          description:
            'SMTP connection prefix or sending mail, depends on mail_smtpmode '\
            'if this is used. Can be "", ssl or tls',
          choice: ['', 'ssl', 'tls'],
          type: 'string',
          required: 'optional',
          default: ''

attribute 'owncloud/config/mail_smtpauth',
          display_name: 'ownCloud Mail SMTP Auth',
          description:
            'Whether authentication is needed to send mail, depends on '\
            'mail_smtpmode if this is used',
          choice: %w(true false),
          type: 'string',
          required: 'optional',
          default: 'false'

attribute 'owncloud/config/mail_smtpauthtype',
          display_name: 'ownCloud Mail SMTP Auth Type',
          description:
            'Authentication type needed to send mail, depends on '\
            'mail_smtpmode if this is used. Can be LOGIN, PLAIN or NTLM',
          choice: %w(LOGIN PLAIN NTLM),
          type: 'string',
          required: 'optional',
          default: 'LOGIN'

attribute 'owncloud/config/mail_smtpname',
          display_name: 'ownCloud Mail SMTP Name',
          description:
            'Username to use for sendmail mail, depends on mail_smtpauth if '\
            'this is used',
          type: 'string',
          required: 'optional',
          default: ''

attribute 'owncloud/config/mail_smtppassword',
          display_name: 'ownCloud Mail SMTP Password',
          description:
            'Password to use for sendmail mail, depends on mail_smtpauth if '\
            'this is used',
          type: 'string',
          required: 'optional',
          default: ''

attribute 'owncloud/cron/enabled',
          display_name: 'ownCloud cron enabled',
          description: 'Whether to enable ownCloud cron',
          type: 'string',
          required: 'optional',
          default: 'true'

attribute 'owncloud/cron/min',
          display_name: 'ownCloud cron minute',
          description: 'Minute to run ownCloud cron at',
          type: 'string',
          required: 'optional',
          default: '*/15'

attribute 'owncloud/cron/hour',
          display_name: 'ownCloud cron hour',
          description: 'Hour to run ownCloud cron at',
          type: 'string',
          required: 'optional',
          default: '*'

attribute 'owncloud/cron/day',
          display_name: 'ownCloud cron day',
          description: 'Day of month to run ownCloud cron at',
          type: 'string',
          required: 'optional',
          default: '*'

attribute 'owncloud/cron/month',
          display_name: 'ownCloud cron month',
          description: 'Month to run ownCloud cron at',
          type: 'string',
          required: 'optional',
          default: '*'

attribute 'owncloud/cron/weekday',
          display_name: 'ownCloud cron weekday',
          description: 'Weekday to run ownCloud cron at',
          type: 'string',
          required: 'optional',
          default: '*'

attribute 'owncloud/skip_permissions',
          display_name: 'Skip permissions',
          description:
            'Whether to skip settings the permissions of the ownCloud '\
            'directory. Set this to true when using NFS synced folders.',
          choice: %w(true false),
          type: 'string',
          required: 'optional'

attribute 'owncloud/manage_database',
          display_name: 'database manage',
          description: 'Whether to manage database creation.',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/mysql/instance',
          display_name: 'MySQL database instance name',
          description:
            'MySQL database instance name to run by the mysql_service lwrp '\
            'from the mysql cookbook.',
          type: 'string',
          required: 'optional',
          default: 'default'

attribute 'owncloud/database/data_dir',
          display_name: 'MySQL server data dir',
          description: 'MySQL data files path.',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'owncloud/database/run_group',
          display_name: 'MySQL run group',
          description: 'MySQL system group.',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'owncloud/database/run_user',
          display_name: 'MySQL run user',
          description: 'MySQL system user.',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'owncloud/database/version',
          display_name: 'MySQL server version',
          description:
            'MySQL version to install by the mysql_service lwrp. Refer to '\
            'https://github.com/chef-cookbooks/mysql#platform-support',
          type: 'string',
          required: 'optional',
          default: 'nil'

attribute 'owncloud/mysql/server_root_password',
          display_name: 'Database Root Password',
          description: 'Database admin password to access a database instance.',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'owncloud/encrypt_attributes',
          display_name: 'owncloud encrypt attributes',
          description: 'Whether to encrypt ownCloud attributes containing '\
            'credential secrets.',
          type: 'string',
          choice: %w(true false),
          default: 'false'

grouping 'owncloud/packages',
         title: 'owncloud packages',
         description: 'ownCloud packages'

attribute 'owncloud/packages/core',
          display_name: 'owncloud packages core',
          description: 'ownCloud core package names as array.',
          type: 'array',
          required: 'optional',
          calculated: true

attribute 'owncloud/packages/sqlite',
          display_name: 'owncloud packages sqlite',
          description: 'ownCloud package names array for SQLite.',
          type: 'array',
          required: 'optional',
          calculated: true

attribute 'owncloud/packages/mysql',
          display_name: 'owncloud packages mysql',
          description: 'ownCloud package names array for MySQL.',
          type: 'array',
          required: 'optional',
          calculated: true

attribute 'owncloud/packages/postgresql',
          display_name: 'owncloud packages postgresql',
          description: 'ownCloud package names array for PostgreSQL.',
          type: 'array',
          required: 'optional',
          calculated: true
