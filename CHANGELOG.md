# CHANGELOG for owncloud

This file is used to list changes made in each version of `owncloud`.

## v0.5.0 (2015-04-08)

* Lock cookbook versions on metadata.
* Add option to skip setting permissions (issues [#18](https://github.com/onddo/owncloud-cookbook/issues/18) and [#20](https://github.com/onddo/owncloud-cookbook/pull/20), thanks [LEDfan](https://github.com/LEDfan)).
* Install PHP `5.4` repo on Ubuntu `<= 12.04` ([issue #19](https://github.com/onddo/owncloud-cookbook/issues/19), thanks [Jason Boyles](https://github.com/JasonBoyles) for reporting).
* Run setup from the command line rather than HTTP request.
* Add web services restart again, required by some SSL setups.
* metadata: Update `openssl` cookbook to version `4` ([issue #22](https://github.com/onddo/owncloud-cookbook/issues/22), thanks [LEDfan](https://github.com/LEDfan) for reporting).

## v0.4.2 (2014-12-12)

* metadata: Lock to `mysql` cookbook `~> 5.0`.

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
