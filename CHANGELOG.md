# CHANGELOG for owncloud

This file is used to list changes made in each version of `owncloud`.

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
