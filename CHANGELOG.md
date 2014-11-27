# CHANGELOG for owncloud

This file is used to list changes made in each version of `owncloud`.

## v0.4.1 (2014-11-27)

* Fix Apache httpd `2.4` support: fixes CentOS 7 and Ubuntu 14 support ([issue #16](https://github.com/onddo/owncloud-cookbook/issues/16), thanks [@LEDfan](https://github.com/LEDfan) for reporting).
* README:
 * Update readme about updates ([issue #17](https://github.com/onddo/owncloud-cookbook/pull/17), thanks [@cvl-skubriev](https://github.com/cvl-skubriev)).
 * Add supermarket badge.

## v0.4.0 (2014-06-16)

* Improved support for Ubuntu 13 and above
* Support for custom x509 certificates
* Added attribute to enable or disable web servers sendfile directive
* Handled new config value `trusted_domains`
* Added some failsafe timeout on nginx for big account
* Patch to avoid file corruption with mod_deflate
* Added repo with more recent PHP version for older Ubuntus (< 12.04)

## v0.3.1 (2013-12-30)

* Fixed max upload size on Nginx with SSL

## v0.3.0 (2013-12-29)

* Added attribute to define the maximum file size for uploads
* Updated testing environment
* Fixed compatibility issue with Chef 11.8 due to a bug on http_request resource ([CHEF-4762](https://tickets.opscode.com/browse/CHEF-4762))
* Fixed issue when upgrading from previous ownCloud installation

## v0.2.0 (2013-09-13)

* Nginx supported as web server
* ownCloud deployable from git

## v0.1.0 (2013-08-07)

* Initial release of `owncloud`
