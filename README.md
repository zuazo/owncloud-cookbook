Description
===========

Installs and configures [ownCloud](http://owncloud.org/), an open source personal cloud for data and file sync, share and view.

Requirements
============

## Platform:

* CentOS
* Debian
* Ubuntu

## Cookbooks:

* apache2
* apt
* database
* mysql
* nginx
* openssl
* php
* php-fpm
* postfix
* postgresql

Attributes
==========

<table>
  <tr>
    <td>Attribute</td>
    <td>Description</td>
    <td>Default</td>
  </tr>
  <tr>
    <td><code>node['owncloud']['version']</code></td>
    <td>Version of ownCloud to install</td>
    <td><code>"latest"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['download_url']</code></td>
    <td>Url from where ownCloud will be downloaded</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['deploy_from_git']</code></td>
    <td>Whether ownCloud should be deployed from the git repository</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['git_repo']</code></td>
    <td>Url of the ownCloud git repository</td>
    <td><code>"https://github.com/owncloud/core.git"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['git_ref']</code></td>
    <td>Git reference to deploy</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['www_dir']</code></td>
    <td>Root directory defined in Apache where web documents are stored</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['dir']</code></td>
    <td>Directory where ownCloud will be installed</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['data_dir']</code></td>
    <td>Directory where ownCloud data will be stored</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['server_name']</code></td>
    <td>Sets the server name for the ownCloud virtual host</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['server_aliases']</code></td>
    <td>Sets the server name aliases for the ownCloud virtual host</td>
    <td><code>[ "localhost" ]</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['install_postfix']</code></td>
    <td>Whether to install Postfix when a local MTA is needed</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['web_server']</code></td>
    <td>Web server to use: <code>"apache"</code> or <code>"nginx"</code></td>
    <td><code>"apache"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['php-fpm']['pool']</code></td>
    <td>PHP-FPM pool name to use with ownCloud.</code></td>
    <td><code>"owncloud"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['max_upload_size']</code></td>
    <td>Maximum allowed size for uploaded files.</code></td>
    <td><code>"512M"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['ssl']</code></td>
    <td>Whether ownCloud should accept requests through SSL</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['ssl_key_dir']</code></td>
    <td>The directory to save the generated private SSL key</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['ssl_cert_dir']</code></td>
    <td>The directory to save the generated public SSL certificate</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['admin']['user']</code></td>
    <td>Administrator username</td>
    <td><code>"admin"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['admin']['pass']</code></td>
    <td>Administrator password</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbtype']</code></td>
    <td>Type of database, can be sqlite, mysql or pgsql</td>
    <td><code>"mysql"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbname']</code></td>
    <td>Name of the ownCloud database</td>
    <td><code>"owncloud"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbuser']</code></td>
    <td>User to access the ownCloud database</td>
    <td><code>"owncloud"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbpassword']</code></td>
    <td>Password to access the ownCloud database</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbhost']</code></td>
    <td>Host running the ownCloud database</td>
    <td><code>"localhost"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbtableprefix']</code></td>
    <td>Prefix for the ownCloud tables in the database</td>
    <td><code>""</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtpmode']</code></td>
    <td>Mode to use for sending mail, can be sendmail, smtp, qmail or php</td>
    <td><code>"sendmail"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtphost']</code></td>
    <td>Host to use for sending mail, depends on mail_smtpmode if this is used</td>
    <td><code>"127.0.0.1"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtpport']</code></td>
    <td>Port to use for sending mail, depends on mail_smtpmode if this is used</td>
    <td><code>25</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtptimeout']</code></td>
    <td>SMTP server timeout in seconds for sending mail, depends on mail_smtpmode if this is used</td>
    <td><code>10</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtpsecure']</code></td>
    <td>SMTP connection prefix or sending mail, depends on mail_smtpmode if this is used. Can be "", ssl or tls</td>
    <td><code>""</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtpauth']</code></td>
    <td>Whether authentication is needed to send mail, depends on mail_smtpmode if this is used</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtpauthtype']</code></td>
    <td>authentication type needed to send mail, depends on mail_smtpmode if this is used. Can be LOGIN, PLAIN or NTLM</td>
    <td><code>"LOGIN"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtpname']</code></td>
    <td>Username to use for sendmail mail, depends on mail_smtpauth if this is used</td>
    <td><code>""</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtppassword']</code></td>
    <td>Password to use for sendmail mail, depends on mail_smtpauth if this is used</td>
    <td><code>""</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['enabled']</code></td>
    <td>Whether to enable ownCloud cron</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['min']</code></td>
    <td>Minute to run ownCloud cron at</td>
    <td><code>"*/15"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['hour']</code></td>
    <td>Hour to run ownCloud cron at</td>
    <td><code>"*"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['day']</code></td>
    <td>Day of month to run ownCloud cron at</td>
    <td><code>"*"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['month']</code></td>
    <td>Month to run ownCloud cron at</td>
    <td><code>"*"</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['weekday']</code></td>
    <td>Weekday to run ownCloud cron at</td>
    <td><code>"*"</code></td>
  </tr>
</table>

Recipes
=======

## owncloud::default

Installs and configures ownCloud.

Usage
=====

Add `recipe[owncloud]` to your node's run list or role, or include it in another cookbook.

The back-end database will be [MySQL](http://www.mysql.com/) by default, but [PostgreSQL](http://www.postgresql.org/) and [SQLite](http://www.sqlite.org/) databases can aslo be used. Database type can be set on `node['owncloud']['config']['dbtype']`, supported values are `mysql`, `pgsql` and `sqlite`.

On the first run, several passwords will be automatically generated and stored in the node:

* `node['owncloud']['admin']['pass']`
* `node['owncloud']['config']['dbpassword']` (Only when using *MySQL* or *PostgreSQL*)
* `node['mysql']['server_root_password']` (Only when using *MySQL*)
* `node['mysql']['server_repl_password']` (Only when using *MySQL*)
* `node['mysql']['server_debian_password']` (Only when using *MySQL*)
* `node['postgresql']['password']['postgres']` (Only when using *PosgreSQL*)

When using Chef Solo, these passwords need to be set manually.

The attribute `node['owncloud']['server_name']` should be set to the domain name used by the ownCloud installation. If not set, `node['fqdn']` will be used instead.

By default ownCloud cookbook relies on a local *Postfix* installation to send emails. But a remote SMTP server can be used changing `node['owncloud']['config']['mail_smtpmode']` to `smtp` and setting up the rest of the mail configuration attributes (see example below).

## Examples

### Basic owncloud role

```ruby
name "owncloud"
description "Install ownCloud"
default_attributes(
  "owncloud" => {
    "server_name" => "cloud.mysite.com"
  }
)
run_list(
  "recipe[owncloud]"
)
```

### Using remote SMTP server

In this example an [Amazon Simple Email Service](http://aws.amazon.com/ses/) account is used to send emails.

```ruby
name "owncloud_ses"
description "Install ownCloud and use an AWS SES account to send emails"
default_attributes(
  "owncloud" => {
    "server_name" => "cloud.mysite.com",
    "config" => {
      "mail_smtpmode" => "smtp",
      "mail_smtphost" => "email-smtp.us-east-1.amazonaws.com",
      "mail_smtpport" => 465,
      "mail_smtpsecure" => "tls",
      "mail_smtpauth" => true,
      "mail_smtpauthtype" => "LOGIN",
      "mail_smtpname" => "amazon-ses-username",
      "mail_smtppassword" => "amazon-ses-password",
    }
  }
)
run_list(
  "recipe[owncloud]"
)
```

### Deploying from Git

The ownCloud code can be deployed from the Git repository. Git recipe must be included on the run_list.

```ruby
name "owncloud_git"
description "Install ownCloud from Git"
default_attributes(
  "owncloud" => {
    "server_name" => "cloud.mysite.com",
    "deploy_from_git" => true,
    "git_ref" => "master"
  }
)
run_list(
  "recipe[git::default]",
  "recipe[owncloud]"
)
```

Testing
=======

## Requirements

You must have VirtualBox(https://www.virtualbox.org/) and Vagrant(http://www.vagrantup.com/) installed.

Install gem dependencies with bundler:

```bash
$ gem install bundler
$ bundle install
```

## Running the tests

```bash
$ bundle exec kitchen test
```

Contributing
============

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Author
==================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | Raúl Rodríguez (<raul@onddo.com>)
| **Author:**          | Xabier de Zuazo (<xabier@onddo.com>)
| **Copyright:**       | Copyright (c) 2013 Onddo Labs, SL. (www.onddo.com)
| **License:**         | Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
