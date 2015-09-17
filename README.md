Description
===========
[![Cookbook Version](https://img.shields.io/cookbook/v/owncloud.svg?style=flat)](https://supermarket.getchef.com/cookbooks/owncloud)
[![Build Status](http://img.shields.io/travis/zuazo/owncloud-cookbook.svg?style=flat)](https://travis-ci.org/zuazo/owncloud-cookbook)
[![Coverage Status](http://img.shields.io/coveralls/zuazo/owncloud-cookbook.svg?style=flat)](https://coveralls.io/r/zuazo/owncloud-cookbook?branch=master)

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
* cron
* database
* mysql
* nginx
* openssl
* php
* php-fpm
* postfix
* postgresql
* ssl_certificate

## Required Applications

* Chef `>= 11.14.2`.
* Ruby `1.9.3` or higher.

## Other Requirements

On RedHat based platforms, you need to disable or configure SELinux correctly. You can use the `selinux::disabled` recipe for that.

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
    <td><code>'latest'</code></td>
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
    <td><code>'https://github.com/owncloud/core.git'</code></td>
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
    <td><code>[]</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['install_postfix']</code></td>
    <td>Whether to install Postfix when a local MTA is needed</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['web_server']</code></td>
    <td>Web server to use: <code>'apache'</code> or <code>'nginx'</code></td>
    <td><code>'apache'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['php-fpm']['pool']</code></td>
    <td>PHP-FPM pool name to use with ownCloud.</code></td>
    <td><code>'owncloud'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['max_upload_size']</code></td>
    <td>Maximum allowed size for uploaded files.</code></td>
    <td><code>'512M'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['sendfile']</code></td>
    <td>Whether to enable Sendfile on web server. You should set to false if you use NFS or SMB mounts.</code></td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['ssl']</code></td>
    <td>Whether ownCloud should accept requests through SSL</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['admin']['user']</code></td>
    <td>Administrator username</td>
    <td><code>'admin'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['admin']['pass']</code></td>
    <td>Administrator password</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbtype']</code></td>
    <td>Type of database, can be sqlite, mysql or pgsql</td>
    <td><code>'mysql'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbname']</code></td>
    <td>Name of the ownCloud database</td>
    <td><code>'owncloud'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbuser']</code></td>
    <td>User to access the ownCloud database</td>
    <td><code>'owncloud'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbpassword']</code></td>
    <td>Password to access the ownCloud database</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbhost']</code></td>
    <td>Host running the ownCloud database</td>
    <td><code>'127.0.0.1'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbport']</code></td>
    <td>Port the ownCloud database is running at</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['dbtableprefix']</code></td>
    <td>Prefix for the ownCloud tables in the database</td>
    <td><code>''</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtpmode']</code></td>
    <td>Mode to use for sending mail, can be sendmail, smtp, qmail or php</td>
    <td><code>'sendmail'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtphost']</code></td>
    <td>Host to use for sending mail, depends on mail_smtpmode if this is used</td>
    <td><code>'127.0.0.1'</code></td>
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
    <td>SMTP connection prefix or sending mail, depends on mail_smtpmode if this is used. Can be '', ssl or tls</td>
    <td><code>''</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtpauth']</code></td>
    <td>Whether authentication is needed to send mail, depends on mail_smtpmode if this is used</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtpauthtype']</code></td>
    <td>Authentication type needed to send mail, depends on mail_smtpmode if this is used. Can be LOGIN, PLAIN or NTLM</td>
    <td><code>'LOGIN'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtpname']</code></td>
    <td>Username to use for sendmail mail, depends on mail_smtpauth if this is used</td>
    <td><code>''</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['config']['mail_smtppassword']</code></td>
    <td>Password to use for sendmail mail, depends on mail_smtpauth if this is used</td>
    <td><code>''</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['enabled']</code></td>
    <td>Whether to enable ownCloud cron</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['min']</code></td>
    <td>Minute to run ownCloud cron at</td>
    <td><code>'*/15'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['hour']</code></td>
    <td>Hour to run ownCloud cron at</td>
    <td><code>'*'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['day']</code></td>
    <td>Day of month to run ownCloud cron at</td>
    <td><code>'*'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['month']</code></td>
    <td>Month to run ownCloud cron at</td>
    <td><code>'*'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['cron']['weekday']</code></td>
    <td>Weekday to run ownCloud cron at</td>
    <td><code>'*'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['skip_permissions']</code></td>
    <td>Whether to skip settings the permissions of the ownCloud directory. Set this to true when using NFS synced folders.</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['database']['rootpassword']</code></td>
    <td>Database admin password to access a database instance</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['database']['instance']</code></td>
    <td>MySQL database instance name to run by the mysql_service lwrp from the mysql cookbook</td>
    <td><code>'default'</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['database']['version']</code></td>
    <td>MySQL version to install by the mysql_service lwrp. Refer to https://github.com/chef-cookbooks/mysql#platform-support</td>
    <td><code>nil</code></td>
  </tr>
  <tr>
    <td><code>node['owncloud']['database']['data_dir']</code></td>
    <td>MySQL data files path</td>
    <td><em>calculated</em></td>
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
* `node['owncloud']['database']['rootpassword']` (Only when using *MySQL* or *PostgreSQL*)

When using Chef Solo, these passwords need to be set manually.

The attribute `node['owncloud']['server_name']` should be set to the domain name used by the ownCloud installation. If not set, `node['fqdn']` will be used instead.

By default ownCloud cookbook relies on a local *Postfix* installation to send emails. But a remote SMTP server can be used changing `node['owncloud']['config']['mail_smtpmode']` to `smtp` and setting up the rest of the mail configuration attributes (see example below).

## Examples

### Basic owncloud role

```ruby
name 'owncloud'
description 'Install ownCloud'
default_attributes(
  'owncloud' => {
    'server_name' => 'cloud.mysite.com'
  }
)
run_list(
  'recipe[owncloud]'
)
```

### Using remote SMTP server

In this example an [Amazon Simple Email Service](http://aws.amazon.com/ses/) account is used to send emails.

```ruby
name 'owncloud_ses'
description 'Install ownCloud and use an AWS SES account to send emails'
default_attributes(
  'owncloud' => {
    'server_name' => 'cloud.mysite.com',
    'config' => {
      'mail_smtpmode' => 'smtp',
      'mail_smtphost' => 'email-smtp.us-east-1.amazonaws.com',
      'mail_smtpport' => 465,
      'mail_smtpsecure' => 'tls',
      'mail_smtpauth' => true,
      'mail_smtpauthtype' => 'LOGIN',
      'mail_smtpname' => 'amazon-ses-username',
      'mail_smtppassword' => 'amazon-ses-password'
    }
  }
)
run_list(
  'recipe[owncloud]'
)
```

### Deploying from Git

The ownCloud code can be deployed from the Git repository. Git recipe must be included on the run_list.

```ruby
name 'owncloud_git'
description 'Install ownCloud from Git'
default_attributes(
  'owncloud' => {
    'server_name' => 'cloud.mysite.com',
    'deploy_from_git' => true,
    'git_ref' => 'master'
  }
)
run_list(
  'recipe[git::default]',
  'recipe[owncloud]'
)
```

## The HTTPS Certificate

OwnCloud will accept HTTPS requests when `node['owncloud']['ssl']` is set to `true`. By default the cookbook will create a self-signed certificate, but a custom one can also be used.

The custom certificate can be read from several sources:

* Attribute
* Data Bag
* Encrypted Data Bag
* Chef Vault
* File

This cookbook uses the [`ssl_certificate`](https://supermarket.chef.io/cookbooks/ssl_certificate) cookbook to create the HTTPS certificate. The namespace used is `node['owncloud']`. For example:

```ruby
node.default['owncloud']['common_name'] = 'owncloud.example.com'
include_recipe 'owncloud'
```

See the [`ssl_certificate` namespace documentation](https://supermarket.chef.io/cookbooks/ssl_certificate#namespaces) for more information.

### Custom HTTPS certificate from an Attribute

```ruby
name 'owncloud_ssl_attribute'
description 'Install ownCloud with a custom SSL certificate from an Attribute'
default_attributes(
  'owncloud' => {
    'server_name' => 'cloud.mysite.com',
    'ssl' => true,
    'ssl_key' => {
      'source' => 'attribute',
      'content' => '-----BEGIN PRIVATE KEY-----[...]'
    },
    'ssl_cert' => {
      'source' => 'attribute',
      'content' => '-----BEGIN CERTIFICATE-----[...]'
    }
  }
)
run_list(
  'recipe[owncloud]'
)
```

### Custom HTTPS certificate from a Data Bag

```ruby
name 'owncloud_ssl_data_bag'
description 'Install ownCloud with a custom SSL certificate from a Data Bag'
default_attributes(
  'owncloud' => {
    'server_name' => 'cloud.mysite.com',
    'ssl' => true,
    'ssl_key' => {
      'source' => 'data-bag',
      'bag' => 'ssl',
      'item' => 'key',
      'item_key' => 'content',
      'encrypted' => true,
      'secret_file' => '/path/to/secret/file' # optional
    },
    'ssl_cert' => {
      'source' => 'data-bag',
      'bag' => 'ssl',
      'item' => 'cert',
      'item_key' => 'content',
      'encrypted' => false
    }
  }
)
run_list(
  'recipe[owncloud]'
)
```

### Custom HTTPS certificate from Chef Vault

```ruby
name 'owncloud_ssl_chef_vault'
description 'Install ownCloud with a custom SSL certificate from Chef Vault'
default_attributes(
  'owncloud' => {
    'server_name' => 'cloud.mysite.com',
    'ssl' => true,
    'ssl_key' => {
      'source' => 'chef-vault',
      'bag' => 'owncloud',
      'item' => 'ssl',
      'item_key' => 'key'
    },
    'ssl_cert' => {
      'source' => 'chef-vault',
      'bag' => 'owncloud',
      'item' => 'ssl',
      'item_key' => 'cert'
    }
  }
)
run_list(
  'recipe[owncloud]'
)
```

### Custom HTTPS certificate from file

This is usefull if you create the certificate on another cookbook.

```ruby
name 'owncloud_ssl_file'
description 'Install ownCloud with a custom SSL certificate from file'
default_attributes(
  'owncloud' => {
    'server_name' => 'cloud.mysite.com',
    'ssl' => true,
    'ssl_key' => {
      'source' => 'file',
      'path' => '/path/to/ssl/key'
    },
    'ssl_cert' => {
      'source' => 'file',
      'path' => '/path/to/ssl/cert'
    }
  }
)
run_list(
  'recipe[owncloud]'
)
```

Upgrading application
=======

If new owncloud version is released and you has notified in web user interface about update available, then you must re-run chef-client on owncloud server.

Cookbook recipes will download latest release version and install it to server.

Then you must proceed with update in web interface and system will be updated.

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

### Running the tests in the cloud

You can run the tests in the cloud instead of using vagrant. First, you must set the following environment variables:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_KEYPAIR_NAME`: EC2 SSH public key name. This is the name used in Amazon EC2 Console's Key Pairs section.
* `EC2_SSH_KEY_PATH`: EC2 SSH private key local full path. Only when you are not using an SSH Agent.
* `DIGITAL_OCEAN_CLIENT_ID`
* `DIGITAL_OCEAN_API_KEY`
* `DIGITAL_OCEAN_SSH_KEY_IDS`: DigitalOcean SSH numeric key IDs.
* `DIGITAL_OCEAN_SSH_KEY_PATH`: DigitalOcean SSH private key local full path. Only when you are not using an SSH Agent.

Then, you must configure test-kitchen to use `.kitchen.cloud.yml` configuration file:

    $ export KITCHEN_LOCAL_YAML='.kitchen.cloud.yml'
    $ bundle exec kitchen test

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
| **Author:**          | [Raul Rodriguez](https://github.com/raulr) (<raul@onddo.com>)
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@onddo.com>)
| **Contributor:**     | [Nacer Laradji](https://github.com/laradji)
| **Contributor:**     | [LEDfan](https://github.com/LEDfan)
| **Contributor:**     | [avsh](https://github.com/avsh)
| **Contributor:**     | [@cvl-skubriev](https://github.com/cvl-skubriev)
| **Contributor:**     | [Michael Sprauer](https://github.com/MichaelSp)
| **Copyright:**       | Copyright (c) 2013-2015 Onddo Labs, SL. (www.onddo.com)
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
