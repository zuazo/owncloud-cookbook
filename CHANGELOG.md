# CHANGELOG for owncloud

This file is used to list changes made in each version of `owncloud`.

## master (unreleased):

* Fix apache 2.4 support: fixes CentOS 7 and Ubuntu 14 support ([issue #16](https://github.com/onddo/owncloud-cookbook/issues/16), thanks [@LEDfan](https://github.com/LEDfan) for reporting).

## 0.4.0:

* Improved support for Ubuntu 13 and above
* Support for custom x509 certificates
* Added attribute to enable or disable web servers sendfile directive
* Handled new config value `trusted_domains`
* Added some failsafe timeout on nginx for big account
* Patch to avoid file corruption with mod_deflate
* Added repo with more recent PHP version for older Ubuntus (< 12.04)

## 0.3.1:

* Fixed max upload size on Nginx with SSL

## 0.3.0:

* Added attribute to define the maximum file size for uploads
* Updated testing environment
* Fixed compatibility issue with Chef 11.8 due to a bug on http_request resource ([CHEF-4762](https://tickets.opscode.com/browse/CHEF-4762))
* Fixed issue when upgrading from previous ownCloud installation

## 0.2.0:

* Nginx supported as web server
* ownCloud deployable from git

## 0.1.0:

* Initial release of `owncloud`
