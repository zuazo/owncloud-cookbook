ownCloud Cookbook
=================
[![Cookbook Version](https://img.shields.io/cookbook/v/owncloud.svg?style=flat)](https://supermarket.chef.io/cookbooks/owncloud)
[![GitHub Source](https://img.shields.io/badge/source-GitHub-blue.svg?style=flat)](https://github.com/zuazo/owncloud-cookbook)
[![Dependency Status](http://img.shields.io/gemnasium/zuazo/owncloud-cookbook.svg?style=flat)](https://gemnasium.com/zuazo/owncloud-cookbook)
[![Code Climate](http://img.shields.io/codeclimate/github/zuazo/owncloud-cookbook.svg?style=flat)](https://codeclimate.com/github/zuazo/owncloud-cookbook)
[![Build Status](http://img.shields.io/travis/zuazo/owncloud-cookbook/1.0.0.svg?style=flat)](https://travis-ci.org/zuazo/owncloud-cookbook)
[![Coverage Status](http://img.shields.io/coveralls/zuazo/owncloud-cookbook/1.0.0.svg?style=flat)](https://coveralls.io/r/zuazo/owncloud-cookbook?branch=1.0.0)
[![Inline docs](http://inch-ci.org/github/zuazo/owncloud-cookbook.svg?branch=master&style=flat)](http://inch-ci.org/github/zuazo/owncloud-cookbook)

[Chef](https://www.chef.io/) cookbook to install and configure [ownCloud](http://owncloud.org/), an open source personal cloud for data and file sync, share and view.

Requirements
============

## Supported Platforms

* CentOS
* Debian
* Scientific Linux
* Ubuntu

The following platforms are tested with Test Kitchen:

| Platform           | MySQL      | PostgreSQL | SQLite     | NGINX      |
|:-------------------|:----------:|:----------:|:----------:|:-----------|
| CentOS 5           | ✔          |            |            |            |
| CentOS 6           | ✔ (travis) |            | ✔ (travis) |            |
| CentOS 7           | ✔          | ✔          | ✔          | ✔          |
| Debian 6           | ✔          |            | ✔          | ✔          |
| Debian 7           | ✔ (travis) | ✔ (travis) | ✔ (travis) | ✔ (travis) |
| Debian 8           | ✔ (travis) | ✔ (travis) | ✔ (travis) | ✔ (travis) |
| Ubuntu 12.04       | ✔          | ✔ (travis) | ✔ (travis) | ✔          |
| Ubuntu 14.04       | ✔          | ✔ (travis) | ✔ (travis) | ✔          |
| Ubuntu 15.04       | ✔          |            | ✔ (travis) | ✔          |
| Scientific Linux 6 | ✔ (travis) |            | ✔ (travis) |            |

Please, [let me know](https://github.com/zuazo/owncloud-cookbook/issues/new?title=I%20have%20used%20it%20successfully%20on%20...) if you use it successfully on any other platform.

## Required Cookbooks

* [apache2](https://supermarket.chef.io/cookbooks/apache2/)
* [apt](https://supermarket.chef.io/cookbooks/apt/)
* [cron](https://supermarket.chef.io/cookbooks/cron/)
* [database](https://supermarket.chef.io/cookbooks/database/)
* [encrypted_attributes](https://supermarket.chef.io/cookbooks/encrypted_attributes/)
* [mysql2_chef_gem](https://supermarket.chef.io/cookbooks/mysql2_chef_gem/)
* [mysql](https://supermarket.chef.io/cookbooks/mysql/)
* [nginx](https://supermarket.chef.io/cookbooks/nginx/)
* [openssl](https://supermarket.chef.io/cookbooks/openssl/)
* [php](https://supermarket.chef.io/cookbooks/php/)
* [php-fpm](https://supermarket.chef.io/cookbooks/php-fpm/)
* [postfix](https://supermarket.chef.io/cookbooks/postfix/)
* [postgresql](https://supermarket.chef.io/cookbooks/postgresql/)
* [ssl_certificate](https://supermarket.chef.io/cookbooks/ssl_certificate/)

## Required Applications

* Chef `>= 11.14.2`.
* Ruby `2.0.0` or higher.

## Other Requirements

On RedHat based platforms, you need to disable or configure SELinux correctly. You can use the `selinux::disabled` recipe for that.

Attributes
==========

| Attribute                                           | Default       | Description                    |
|:----------------------------------------------------|:--------------|:-------------------------------|
| `node['owncloud']['version']`                       | *calculated*  | Version of ownCloud to install.
| `node['owncloud']['download_url']`                  | *calculated*  | URL from where ownCloud will be downloaded.
| `node['owncloud']['deploy_from_git']`               | `false`       | Whether ownCloud should be deployed from the git repository.
| `node['owncloud']['git_repo']`                      | *calculated*  | URL of the ownCloud git repository.
| `node['owncloud']['git_ref']`                       | `nil`         | Git reference to deploy.
| `node['owncloud']['www_dir']`                       | *calculated*  | Root directory defined in the web server where web documents are stored.
| `node['owncloud']['dir']`                           | *calculated*  | Directory where ownCloud will be installed.
| `node['owncloud']['data_dir']`                      | *calculated*  | Directory where ownCloud data will be stored.
| `node['owncloud']['server_name']`                   | *calculated*  | Sets the server name for the ownCloud virtual host.
| `node['owncloud']['server_aliases']`                | `[]`          | Sets the server name aliases for the ownCloud virtual host.
| `node['owncloud']['install_postfix']`               | `true`        | Whether to install Postfix when a local MTA is needed.
| `node['owncloud']['web_server']`                    | `'apache'`    | Web server to use: `'apache'` or `'nginx'`.
| `node['owncloud']['php-fpm']['pool']`               | `'owncloud'`  | PHP-FPM pool name to use with ownCloud.
| `node['owncloud']['max_upload_size']`               | `'512M'`      | Maximum allowed size for uploaded files.
| `node['owncloud']['sendfile']`                      | *calculated*  | Whether to enable *sendfile* on web server. You should set to `'false'` if you use NFS or SMB mounts.
| `node['owncloud']['ssl']`                           | `true`        | Whether ownCloud should accept requests through TLS.
| `node['owncloud']['admin']['user']`                 | `'admin'`     | Administrator username.
| `node['owncloud']['admin']['pass']`                 | *calculated*  | Administrator password.
| `node['owncloud']['config']['dbtype']`              | `'mysql'`     | Type of database, can be `'sqlite'`, `'mysql'` or `'pgsql'`.
| `node['owncloud']['config']['dbname']`              | `'owncloud'`  | Name of the ownCloud database.
| `node['owncloud']['config']['dbuser']`              | `'owncloud'`  | User to access the ownCloud database.
| `node['owncloud']['config']['dbpassword']`          | *calculated*  | Password to access the ownCloud database.
| `node['owncloud']['config']['dbhost']`              | `'127.0.0.1'` | Host running the ownCloud database.
| `node['owncloud']['config']['dbport']`              | *calculated*  | Port the ownCloud database is running at.
| `node['owncloud']['config']['dbtableprefix']`       | `''`          | Prefix for the ownCloud tables in the database.
| `node['owncloud']['config']['mail_smtpmode']`       | `'sendmail'`  | Mode to use for sending mail, can be `'sendmail'`, `'smtp'`, `'qmail'` or `'php'`.
| `node['owncloud']['config']['mail_smtphost']`       | `'127.0.0.1'` | Host to use for sending mail, depends on *mail_smtpmode* if this is used.
| `node['owncloud']['config']['mail_smtpport']`       | `25`          | Port to use for sending mail, depends on *mail_smtpmode* if this is used.
| `node['owncloud']['config']['mail_smtptimeout']`    | `10`          | SMTP server timeout in seconds for sending mail, depends on *mail_smtpmode* if this is used.
| `node['owncloud']['config']['mail_smtpsecure']`     | `''`          | SMTP connection prefix or sending mail, depends on *mail_smtpmode* if this is used. Can be `''`, `'ssl'` or `'tls'`.
| `node['owncloud']['config']['mail_smtpauth']`       | `false`       | Whether authentication is needed to send mail, depends on *mail_smtpmode* if this is used.
| `node['owncloud']['config']['mail_smtpauthtype']`   | `'LOGIN'`     | Authentication type needed to send mail, depends on *mail_smtpmode* if this is used. Can be `'LOGIN'`, `'PLAIN'` or `'NTLM'`.
| `node['owncloud']['config']['mail_smtpname']`       | `''`          | Username to use for sendmail mail, depends on *mail_smtpauth* if this is used.
| `node['owncloud']['config']['mail_smtppassword']`   | `''`          | Password to use for sendmail mail, depends on *mail_smtpauth* if this is used.
| `node['owncloud']['cron']['enabled']`               | `true`        | Whether to enable ownCloud cron job.
| `node['owncloud']['cron']['min']`                   | `'*/15'`      | Minute to run ownCloud cron at.
| `node['owncloud']['cron']['hour']`                  | `'*'`         | Hour to run ownCloud cron at.
| `node['owncloud']['cron']['day']`                   | `'*'`         | Day of month to run ownCloud cron at.
| `node['owncloud']['cron']['month']`                 | `'*'`         | Month to run ownCloud cron at.
| `node['owncloud']['cron']['weekday']`               | `'*'`         | Weekday to run ownCloud cron at.
| `node['owncloud']['skip_permissions']`              | `false`       | Whether to skip settings the permissions of the ownCloud directory. Set this to `true` when using NFS synced folders.
| `node['owncloud']['manage_database']`               | *calculated*  | Whether to manage database creation.
| `node['owncloud']['mysql']['instance']`             | `'default'`   | MySQL database instance name to run by the `mysql_service` LWRP from the [mysql](https://supermarket.chef.io/cookbooks/mysql) cookbook.
| `node['owncloud']['mysql']['data_dir']`             | *calculated*  | MySQL data files path.
| `node['owncloud']['mysql']['run_group']`            | *calculated*  | MySQL system group.
| `node['owncloud']['mysql']['run_user']`             | *calculated*  | MySQL system user.
| `node['owncloud']['mysql']['version']`              | `nil`         | MySQL version to install by the `mysql_service` LWRP. Refer to [`mysql` cookbook platform support section](https://github.com/chef-cookbooks/mysql#platform-support).
| `node['owncloud']['mysql']['server_root_password']` | *calculated*  | MySQL root password to access a database instance.
| `node['owncloud']['encrypt_attributes']`            | `false`       | Whether to encrypt ownCloud attributes containing credential secrets.

## Platform Support Related Attributes

Some cookbook attributes are used internally to support the different platforms. Surely you want to change them if you want to support new platforms or want to improve the support of some platforms already supported.

| Attribute                                | Default       | Description                       |
|:-----------------------------------------|:--------------|:----------------------------------|
| `node['owncloud']['packages']['core']`   | *calculated*  | ownCloud core package names as array.
| `node['owncloud']['packages']['sqlite']` | *calculated*  | ownCloud package names array for SQLite.
| `node['owncloud']['packages']['mysql']`  | *calculated*  | ownCloud package names array for MySQL.
| `node['owncloud']['packages']['pgsql']`  | *calculated*  | ownCloud package names array for PostgreSQL.

Recipes
=======

## owncloud::default

Installs and configures ownCloud.

Usage
=====

Add `recipe[owncloud]` to your node's run list or role, or include it in another cookbook.

The back-end database will be [MySQL](http://www.mysql.com/) by default, but [PostgreSQL](http://www.postgresql.org/) and [SQLite](http://www.sqlite.org/) databases can also be used. Database type can be set on `node['owncloud']['config']['dbtype']`, supported values are `mysql`, `pgsql` and `sqlite`.

On the first run, several passwords will be automatically generated and stored in the node:

* `node['owncloud']['admin']['pass']`
* `node['owncloud']['config']['dbpassword']` (Only when using *MySQL* or *PostgreSQL*)
* `node['owncloud']['mysql']['server_root_password']` (Only when using *MySQL*)

When using Chef Solo, these passwords need to be set manually.

The attribute `node['owncloud']['server_name']` should be set to the domain name used by the ownCloud installation. If not set, `node['fqdn']` will be used instead.

By default ownCloud cookbook relies on a local *Postfix* installation to send emails. But a remote SMTP server can be used changing `node['owncloud']['config']['mail_smtpmode']` to `smtp` and setting up the rest of the mail configuration attributes (see example below).

## Examples

### Basic ownCloud Role

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

### Using Remote SMTP Server

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

ownCloud will accept HTTPS requests when `node['owncloud']['ssl']` is set to `true`. By default the cookbook will create a self-signed certificate, but a custom one can also be used.

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

### Custom HTTPS Certificate from an Attribute

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

### Custom HTTPS Certificate from a Data Bag

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

### Custom HTTPS Certificate from Chef Vault

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

### Custom HTTPS Certificate from File

This is useful if you create the certificate on another cookbook.

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

Upgrading the Application
=========================

If new owncloud version is released and you has notified in web user interface about update available, then you must re-run chef-client on owncloud server.

Cookbook recipes will download latest release version and install it to server.

Then you must proceed with update in the web interface and the system will be updated.

Encrypted Attributes
====================

This cookbook can use the [encrypted_attributes](https://supermarket.chef.io/cookbooks/encrypted_attributes) cookbook to encrypt the secrets generated during the *Chef Run*. This feature is disabled by default, but can be enabled setting the `node['owncloud']['encrypt_attributes']` attribute to `true`. For example:

```ruby
include_recipe 'encrypted_attributes::users_data_bag'
node.default['owncloud']['encrypt_attributes'] = true
inclure_recipe 'owncloud'
```

This will create the following encrypted attributes:

* `node['owncloud']['admin']['pass']`: ownCloud Admin password.
* `node['owncloud']['mysql']['server_root_password']`: MySQL *root* user password.
* `node['owncloud']['config']['dbpassword']`: MySQL ownCloud user password.

Read the [`chef-encrypted-attributes` gem documentation](http://onddo.github.io/chef-encrypted-attributes/) to learn how to read them.

**Warning:** When PostgreSQL is used, the database root password will still remain unencrypted in the `node['postgresql']['password']['postgres']` attribute due to limitations of the [postgresql cookbook](https://supermarket.chef.io/cookbooks/postgresql).

PostgreSQL Support
==================

ownCloud with PostgreSQL may not work properly on some platforms. [Any feedback you can provide regarding the PostgreSQL support](https://github.com/zuazo/owncloud-cookbook/issues/new?title=PostgreSQL%20Support) will be greatly appreciated.

## PostgreSQL Versions `< 9.3`

If you are using PostgreSQL version `< 9.3`, you may need to adjust the `shmmax` and `shmall` kernel parameters to configure the shared memory. You can see [the example used for the integration tests](https://github.com/zuazo/owncloud-cookbook/tree/master/test/cookbooks/owncloud_test/recipes/postgresql_memory.rb).

Deploy with Docker
==================

You can use the *Dockerfile* included in the [cookbook source code](https://github.com/zuazo/owncloud-cookbook) to run the cookbook inside a container:

    $ docker build -t chef-owncloud .
    $ docker run -ti chef-owncloud

The sample *Dockerfile*:

```Dockerfile
FROM zuazo/chef-local:debian-7

COPY . /tmp/owncloud
RUN berks vendor -b /tmp/owncloud/Berksfile $COOKBOOK_PATH
RUN chef-client -r "recipe[owncloud]"

EXPOSE 80

CMD ["apache2", "-D", "FOREGROUND"]
```

See the [chef-local container documentation](https://hub.docker.com/r/zuazo/chef-local/) for more examples.

Testing
=======

See [TESTING.md](https://github.com/zuazo/owncloud-cookbook/blob/master/TESTING.md).

Contributing
============

Please do not hesitate to [open an issue](https://github.com/zuazo/owncloud-cookbook/issues/new) with any questions or problems.

See [CONTRIBUTING.md](https://github.com/zuazo/owncloud-cookbook/blob/master/CONTRIBUTING.md).

TODO
====

See [TODO.md](https://github.com/zuazo/owncloud-cookbook/blob/master/TODO.md).


License and Author
==================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Raul Rodriguez](https://github.com/raulr) (<raul@onddo.com>)
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@zuazo.org>)
| **Contributor:**     | [Nacer Laradji](https://github.com/laradji)
| **Contributor:**     | [LEDfan](https://github.com/LEDfan)
| **Contributor:**     | [@avsh](https://github.com/avsh)
| **Contributor:**     | [@cvl-skubriev](https://github.com/cvl-skubriev)
| **Contributor:**     | [Michael Sprauer](https://github.com/MichaelSp)
| **Copyright:**       | Copyright (c) 2015, Xabier de Zuazo
| **Copyright:**       | Copyright (c) 2013-2015 Onddo Labs, SL.
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
