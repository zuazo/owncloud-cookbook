# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Xabier de Zuazo
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if defined?(ChefSpec)
  def stub_apache2_cookbook
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_command('/usr/sbin/httpd -t').and_return(true)
    stub_command('which php').and_return(true)
  end

  def stub_php_fpm_cookbook
    stub_command(
      'test -d /etc/php5/fpm/pool.d || mkdir -p /etc/php5/fpm/pool.d'
    ).and_return(true)
    stub_command('test -d /etc/php-fpm.d || mkdir -p /etc/php-fpm.d')
      .and_return(true)
  end

  def stub_nginx_cookbook
    stub_php_fpm_cookbook
    stub_command('which nginx').and_return(true)
    allow(::File).to receive(:symlink?).and_call_original
  end

  def stub_postgresql_cookbook
    stub_command(
      "psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{db_name} "\
      "| grep '^ plpgsql$'"
    ).and_return(false)
    stub_command('ls /recovery.conf').and_return(false)
    stub_command('ls /var/lib/postgresql/9.1/main/recovery.conf')
      .and_return(true)
  end

  def stub_postfix_cookbook
    stub_command(
      '/usr/bin/test /etc/alternatives/mta -ef /usr/sbin/sendmail.postfix'
    ).and_return(true)
  end
end
