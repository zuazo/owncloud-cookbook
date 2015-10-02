# encoding: UTF-8
#
# Cookbook Name:: owncloud
# Attributes:: packages
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Xabier de Zuazo
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

case node['platform_family']
when 'debian'
  default['owncloud']['packages']['core'] =
    %w(php5-gd php5-intl php5-curl php5-json smbclient)
  default['owncloud']['packages']['sqlite'] = %w(php5-sqlite)
  default['owncloud']['packages']['mysql'] = %w(php5-mysql)
  default['owncloud']['packages']['pgsql'] = %w(php5-pgsql)
when 'rhel'
  if node['platform'] != 'amazon' && node['platform_version'].to_f < 6
    default['owncloud']['packages']['core'] =
      %w(php53-gd php53-mbstring php53-xml php53-intl samba-client)
    default['owncloud']['packages']['sqlite'] = %w(php53-pdo)
    default['owncloud']['packages']['mysql'] = %w(php53-mysql)
    default['owncloud']['packages']['pgsql'] = %w(php53-pgsql)
  else
    default['owncloud']['packages']['core'] =
      %w(php-gd php-mbstring php-xml php-intl samba-client)
    default['owncloud']['packages']['sqlite'] = %w(php-pdo)
    default['owncloud']['packages']['mysql'] = %w(php-mysql)
    default['owncloud']['packages']['pgsql'] = %w(php-pgsql)
  end
when 'fedora'
  default['owncloud']['packages']['core'] =
    %w(php-gd php-mbstring php-xml php-intl samba-client)
  default['owncloud']['packages']['sqlite'] = %w(php-pdo)
  default['owncloud']['packages']['mysql'] = %w(php-mysql)
  default['owncloud']['packages']['pgsql'] = %w(php-pgsql)
else
  Chef::Log.warn('Unsupported platform, trying to guess packages.')
  default['owncloud']['packages']['core'] =
    %w(php-gd php-mbstring php-xml php-intl samba-client)
  default['owncloud']['packages']['sqlite'] = %w(php-pdo)
  default['owncloud']['packages']['mysql'] = %w(php-mysql)
  default['owncloud']['packages']['pgsql'] = %w(php-pgsql)
end
