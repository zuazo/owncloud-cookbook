# Until sendmail fixed: https://github.com/owncloud/core/issues/19110
default['owncloud']['version'] = '8.0.8'
default['owncloud']['download_url'] =
  'http://download.owncloud.org/community/'\
  "owncloud-#{node['owncloud']['version']}.tar.bz2"
