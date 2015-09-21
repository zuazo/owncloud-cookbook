# encoding: UTF-8
#
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

require_relative '../spec_helper'

describe 'owncloud::default' do
  let(:chef_runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  let(:db_name) { 'owncloud_db' }
  let(:db_user) { 'owncloud_user' }
  let(:db_root_password) { 'root_db_pass' }
  let(:db_password) { 'owncloud_pass' }
  let(:db_host) { node['owncloud']['config']['dbhost'] }
  let(:db_connection) do
    {
      host: db_host, port: '3306',
      username: 'root', password: db_root_password
    }
  end
  let(:admin_password) { 'owncloud_setup' }
  before do
    node.set['owncloud']['config']['dbname'] = db_name
    node.set['owncloud']['config']['dbuser'] = db_user
    node.set['owncloud']['config']['dbpassword'] = db_password
    node.set['owncloud']['mysql']['server_root_password'] = db_root_password
    node.set['owncloud']['admin']['pass'] = admin_password
    node.set['postgresql']['password']['postgres'] = db_root_password

    stub_apache2_cookbook
    stub_postgresql_cookbook
    stub_nginx_cookbook
    stub_postfix_cookbook

    allow(::File).to receive(:exist?).and_call_original
    allow(::File)
      .to receive(:exist?).with('/var/www/owncloud/config/config.php')
      .and_return(false)
  end

  context 'on Ubuntu' do
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04')
    end

    it 'includes apt recipe' do
      expect(chef_run).to include_recipe('apt')
    end
  end # context on Ubuntu

  context 'on Debian' do
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(platform: 'debian', version: '7.0')
    end

    it 'includes apt recipe' do
      expect(chef_run).to include_recipe('apt')
    end
  end # context on Debian

  context 'on CentOS' do
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.0')
    end

    it 'does not include apt recipe' do
      expect(chef_run).to_not include_recipe('apt')
    end
  end # context on CentOS

  context 'without setting database password' do
    before { node.set['owncloud']['config']['dbpassword'] = nil }

    it 'raises an error' do
      expect { chef_run }
        .to raise_error(/You must set ownCloud's database password/)
    end
  end

  context 'without setting database root password' do
    before { node.set['owncloud']['mysql']['server_root_password'] = nil }

    it 'raises an error' do
      expect { chef_run }
        .to raise_error(/You must set the database admin password/)
    end
  end

  context 'without admin password' do
    before { node.set['owncloud']['admin']['pass'] = nil }

    it 'raises an error' do
      expect { chef_run }
        .to raise_error(/You must set ownCloud's admin password/)
    end
  end

  context 'on Ubuntu 12.04' do
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04')
    end

    it 'adds ondrej-php5-oldstable apt repository' do
      expect(chef_run).to add_apt_repository('ondrej-php5-oldstable')
        .with_uri('http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu')
        .with_distribution(node['lsb']['codename'])
        .with_components(%w(main))
        .with_keyserver('keyserver.ubuntu.com')
        .with_key('E5267A6C')
        .with_deb_src(true)
    end
  end # context on Ubuntu 12.04

  context 'on Ubuntu 14.04' do
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
    end

    it 'does not add ondrej-php5-oldstable apt repository' do
      expect(chef_run).to_not add_apt_repository('ondrej-php5-oldstable')
    end
  end # context on Ubuntu 14.04

  it 'includes php recipe' do
    expect(chef_run).to include_recipe('php')
  end

  packages_spec = {
    'debian@7.0' => {
      'core' => %w(php5-gd php5-intl php5-curl php5-json smbclient),
      'sqlite' => %w(php5-sqlite),
      'mysql' => %w(php5-mysql),
      'pgsql' => %w(php5-pgsql)
    },
    'centos@5.10' => {
      'core' => %w(php53-gd php53-mbstring php53-xml php53-intl samba-client),
      'sqlite' => %w(), # Raises an exception
      'mysql' => %w(php53-mysql),
      'pgsql' => %w(php53-pgsql)
    },
    'centos@6.0' => {
      'core' => %w(php-gd php-mbstring php-xml php-intl samba-client),
      'sqlite' => %w(php-pdo),
      'mysql' => %w(php-mysql),
      'pgsql' => %w(php-pgsql)
    },
    'fedora@20' => {
      'core' => %w(php-gd php-mbstring php-xml php-intl samba-client),
      'sqlite' => %w(php-pdo),
      'mysql' => %w(php-mysql),
      'pgsql' => %w(php-pgsql)
    }
  }

  packages_spec.each do |platform_spec, packages_by_type|
    platform, platform_version = platform_spec.split('@', 2)

    context "on #{platform.capitalize} #{platform_version}" do
      let(:chef_runner) do
        ChefSpec::SoloRunner.new(platform: platform, version: platform_version)
      end

      packages_by_type.each do |dbtype, packages|
        context "with #{dbtype} packages" do
          before do
            unless dbtype == 'core'
              node.set['owncloud']['config']['dbtype'] = dbtype
            end
          end

          packages.each do |package|
            it "installs #{package} package" do
              expect(chef_run).to install_package(package)
            end
          end # packages each

          if packages.empty?
            it 'raises database type not supported exception' do
              expect { chef_run }
                .to raise_error(/database type not supported on/)
            end
          end # if packages empty?
        end # context with dbtype packages
      end # packages_by_type each
    end # context on platform platform_version
  end # packages_spec each

  context 'with SQLite database' do
    before { node.set['owncloud']['config']['dbtype'] = 'sqlite' }

    it 'set table prefix to "oc_"' do
      chef_run
      expect(node['owncloud']['config']['dbtableprefix']).to eq('oc_')
    end
  end # context with SQLite database

  context 'with MySQL database' do
    before { node.set['owncloud']['config']['dbtype'] = 'mysql' }

    it 'uses local databse by default' do
      chef_run
      expect(node['owncloud']['config']['dbhost']).to eq(db_host)
    end

    it 'installs mysql2 gem' do
      expect(chef_run).to install_mysql2_chef_gem('default')
    end

    it 'creates MySQL service' do
      expect(chef_run).to create_mysql_service('default')
        .with_data_dir(nil)
        .with_version(nil)
        .with_bind_address(db_host)
        .with_port('3306')
        .with_initial_root_password(db_root_password)
    end

    it 'starts MySQL service' do
      expect(chef_run).to start_mysql_service('default')
    end

    it 'creates MySQL database' do
      expect(chef_run).to create_mysql_database(db_name)
        .with_connection(db_connection)
    end

    it 'grants MySQL user' do
      expect(chef_run).to grant_mysql_database_user(db_user)
        .with_connection(db_connection)
        .with_database_name(db_name)
        .with_host(db_host)
        .with_password(db_password)
        .with_privileges([:all])
    end

    context 'with remote database' do
      before { node.set['owncloud']['config']['dbhost'] = '1.2.3.4' }

      it 'does not install mysql2 gem' do
        expect(chef_run).to_not install_mysql2_chef_gem('default')
      end

      it 'does not create MySQL service' do
        expect(chef_run).to_not create_mysql_service('default')
      end

      it 'does not start MySQL service' do
        expect(chef_run).to_not start_mysql_service('default')
      end

      it 'does not create MySQL database' do
        expect(chef_run).to_not create_mysql_database(db_name)
      end
    end # context with remote database

    context 'with manage remote database' do
      let(:db_host) { '1.2.3.4' }
      before do
        node.set['owncloud']['manage_database'] = true
        node.set['owncloud']['config']['dbhost'] = db_host
      end

      it 'installs mysql2 gem' do
        expect(chef_run).to install_mysql2_chef_gem('default')
      end

      it 'creates MySQL service' do
        expect(chef_run).to create_mysql_service('default')
          .with_data_dir(nil)
          .with_version(nil)
          .with_bind_address(db_host)
          .with_port('3306')
          .with_initial_root_password(db_root_password)
      end

      it 'starts MySQL service' do
        expect(chef_run).to start_mysql_service('default')
      end

      it 'creates MySQL database' do
        expect(chef_run).to create_mysql_database(db_name)
          .with_connection(db_connection)
      end

      it 'grants MySQL user' do
        expect(chef_run).to grant_mysql_database_user(db_user)
          .with_connection(db_connection)
          .with_database_name(db_name)
          .with_host(db_host)
          .with_password(db_password)
          .with_privileges([:all])
      end
    end # context with manage remote database

    context 'without manage local database' do
      let(:db_host) { '127.0.0.1' }
      before do
        node.set['owncloud']['manage_database'] = false
        node.set['owncloud']['config']['dbhost'] = db_host
      end

      it 'does not install mysql2 gem' do
        expect(chef_run).to_not install_mysql2_chef_gem('default')
      end

      it 'does not create MySQL service' do
        expect(chef_run).to_not create_mysql_service('default')
      end

      it 'does not start MySQL service' do
        expect(chef_run).to_not start_mysql_service('default')
      end

      it 'does not create MySQL database' do
        expect(chef_run).to_not create_mysql_database(db_name)
      end
    end # context without manage local database
  end # context with MySQL database

  context 'with PostgreSQL database' do
    let(:db_connection) do
      {
        host: db_host, port: 5432,
        username: 'postgres', password: db_root_password
      }
    end
    before { node.set['owncloud']['config']['dbtype'] = 'pgsql' }

    context 'on Chef Solo' do
      let(:chef_runner) { ChefSpec::SoloRunner.new }

      context 'when password is not set' do
        before { node.set['postgresql']['password']['postgres'] = nil }

        it 'raises an exception' do
          expect { chef_run }.to raise_error(/You must set .*password/)
        end
      end
    end

    it 'includes postgresql::server recipe' do
      expect(chef_run).to include_recipe('postgresql::server')
    end

    it 'includes database::postgresql recipe' do
      expect(chef_run).to include_recipe('database::postgresql')
    end

    it 'creates PostgreSQL database' do
      expect(chef_run).to create_postgresql_database(db_name)
        .with_connection(db_connection)
    end

    it 'creates PostgreSQL database user' do
      expect(chef_run).to create_postgresql_database_user(db_user)
        .with_connection(db_connection)
        .with_host(db_host)
        .with_password(db_password)
    end

    it 'grants PostgreSQL database user' do
      expect(chef_run).to create_postgresql_database_user(db_user)
        .with_connection(db_connection)
        .with_database_name(db_name)
        .with_host(db_host)
        .with_password(db_password)
        .with_privileges([:all])
    end
  end # context with PostgreSQL database

  context 'with unknown database' do
    before { node.set['owncloud']['config']['dbtype'] = 'unknown' }

    it 'raises unsupported database exception' do
      expect { chef_run }.to raise_error(/Unsupported database type/)
    end
  end # context with unknown database

  it 'includes postfix::default recipe' do
    expect(chef_run).to include_recipe('postfix::default')
  end

  context 'on Ubuntu 15.04' do
    # Ubuntu 15.04 still not supported by fauxhai
    before do
      node.automatic['platform_family'] = 'debian'
      node.automatic['platform'] = 'ubuntu'
      node.automatic['platform_version'] = '15.04'
    end

    it 'uses Debian service provider for postfix' do
      expect(chef_run).to enable_service('postfix')
        .with_provider(Chef::Provider::Service::Debian)
    end
  end # context on Ubuntu 15.04

  it 'creates www directory' do
    expect(chef_run).to create_directory('/var/www')
  end

  context 'on CentOS' do
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.0')
    end

    it 'does not use Debian service provider for postfix' do
      expect(chef_run).to enable_service('postfix')
        .with_provider(nil)
    end

    it 'creates www/html directory' do
      expect(chef_run).to create_directory('/var/www/html')
    end
  end # context on CentOS

  it 'does not send a HEAD request' do
    expect(chef_run).to_not head_http_request('HEAD owncloud')
  end

  context 'without deploying from git' do
    let(:local_file) { "#{file_cache_path}/owncloud-latest.tar.bz2" }
    let(:file_time) { instance_double('Time') }
    let(:file_cache_path) { '/var/chef/cache' }
    let(:http_date) { 'HTTP Date' }
    let(:chef_runner) do
      ChefSpec::SoloRunner.new(file_cache_path: file_cache_path)
    end
    before do
      node.set['owncloud']['deploy_from_git'] = false
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with(local_file).and_return(true)
      allow(File).to receive(:mtime).and_call_original
      allow(File).to receive(:mtime).with(local_file).and_return(file_time)
      allow(file_time).to receive(:httpdate).and_return(http_date)
    end

    context 'with Chef 11.6' do
      before { stub_const('Chef::VERSION', '11.6.0') }

      it 'does not send a HEAD request' do
        expect(chef_run).to_not head_http_request('HEAD owncloud')
      end

      it 'downloads owncloud' do
        expect(chef_run).to create_remote_file('download owncloud')
          .with_source(
            'http://download.owncloud.org/community/owncloud-latest.tar.bz2'
          )
          .with_path(local_file)
      end
    end # context with Chef 11.6

    context 'with Chef 11.5' do
      before { stub_const('Chef::VERSION', '11.5.99') }

      it 'send a HEAD request to mimic remote_file conditional get' do
        expect(chef_run).to head_http_request('HEAD owncloud')
          .with_message('')
          .with_url(/owncloud-latest\.tar\.bz2$/)
          .with_headers('If-Modified-Since' => http_date)
      end

      context 'HEAD request resource' do
        let(:resource) { chef_run.http_request('HEAD owncloud') }

        it 'notifies owncloud download resource' do
          expect(resource)
            .to notify('remote_file[download owncloud]').to(:create).immediately
        end
      end

      context 'download owncloud file' do
        let(:resource) { chef_run.remote_file('download owncloud') }

        it 'has action nothing' do
          expect(resource).to do_nothing
        end
      end # context download owncloud file
    end # context with Chef 11.5

    context 'download owncloud file' do
      let(:resource) { chef_run.remote_file('download owncloud') }

      it 'notifies owncloud extract resource' do
        expect(resource)
          .to notify('bash[extract owncloud]').to(:run).immediately
      end
    end

    it 'downloads owncloud' do
      expect(chef_run).to create_remote_file('download owncloud')
        .with_path(local_file)
    end

    context 'extract owncloud resource' do
      let(:resource) { chef_run.bash('extract owncloud') }

      it 'has action nothing' do
        expect(resource).to do_nothing
      end

      it 'has the correct directory' do
        expect(resource.cwd).to eq('/var/www')
      end
    end # context extract owncloud resource
  end # context without deploying from git

  context 'with deploying from git' do
    before { node.set['owncloud']['deploy_from_git'] = true }

    it 'clones git repository' do
      expect(chef_run).to sync_git('clone owncloud')
        .with_destination('/var/www/owncloud')
        .with_repository('https://github.com/owncloud/core.git')
        .with_reference('master')
        .with_enable_submodules(true)
    end

    context 'with git reference' do
      let(:ref) { 'ref001' }
      before { node.set['owncloud']['git_ref'] = ref }
      it 'clones git repository by reference' do
        expect(chef_run).to sync_git('clone owncloud')
          .with_reference(ref)
      end
    end # context with git reference

    context 'with owncloud version' do
      let(:version) { '1.0.0' }
      before { node.set['owncloud']['version'] = version }
      it 'clones git repository by version' do
        expect(chef_run).to sync_git('clone owncloud')
          .with_reference("v#{version}")
      end
    end # context with owncloud version
  end # context with deploying from git

  it 'includes owncloud::_apache recipe' do
    expect(chef_run).to include_recipe('owncloud::_apache')
  end

  it 'creates apps directory' do
    expect(chef_run).to create_directory('/var/www/owncloud/apps')
      .with_owner('www-data')
      .with_group('www-data')
      .with_mode(00750)
  end

  it 'creates config directory' do
    expect(chef_run).to create_directory('/var/www/owncloud/config')
      .with_owner('www-data')
      .with_group('www-data')
      .with_mode(00750)
  end

  it 'creates data directory' do
    expect(chef_run).to create_directory('/var/www/owncloud/data')
      .with_owner('www-data')
      .with_group('www-data')
      .with_mode(00750)
  end

  it 'creates autoconfig.php file' do
    expect(chef_run).to create_template('owncloud autoconfig.php')
      .with_path('/var/www/owncloud/config/autoconfig.php')
      .with_source('autoconfig.php.erb')
      .with_owner('www-data')
      .with_group('www-data')
      .with_mode(00640)
  end

  context 'autoconfig.php template resource' do
    let(:resource) { chef_run.template('owncloud autoconfig.php') }

    it 'notifies apache service restart' do
      expect(resource).to notify('service[apache2]').to(:restart).immediately
    end

    it 'notifies run owncloud setup' do
      expect(resource)
        .to notify('execute[run owncloud setup]').to(:run).immediately
    end
  end # context autoconfig.php template resource

  context 'autoconfig.php file' do
    let(:file) { '/var/www/owncloud/config/autoconfig.php' }

    it 'includes $AUTOCONFIG variable' do
      expect(chef_run).to render_file(file).with_content { |content|
        expect(content).to include('$AUTOCONFIG')
      }
    end
  end

  context 'when config.php exist' do
    before do
      allow(::File)
        .to receive(:exist?).with('/var/www/owncloud/config/config.php')
        .and_return(true)
    end

    it 'does not create autoconfig.php file' do
      expect(chef_run).to_not create_template('owncloud autoconfig.php')
    end
  end

  context 'run owncloud setup resource' do
    let(:resource) { chef_run.execute('run owncloud setup') }

    it 'has action nothing' do
      expect(resource).to do_nothing
    end

    it 'has the correct working directory' do
      expect(resource.cwd).to eq('/var/www/owncloud')
    end

    it 'has the correct command' do
      expect(resource.command).to match(/^sudo -u .* php -f index\.php/)
    end
  end # context run owncloud setup resource

  context 'when config.php exist' do
    before do
      allow(::File)
        .to receive(:exist?).with('/var/www/owncloud/config/config.php')
        .and_return(true)
    end

    it 'applies configuration on attributes to config.php' do
      expect(chef_run).to run_ruby_block('apply owncloud config')
    end
  end

  context 'when config.php does not exist' do
    before do
      allow(::File)
        .to receive(:exist?).with('/var/www/owncloud/config/config.php')
        .and_return(false)
    end

    it 'does not apply owncloud configuration on attributes to config.php' do
      expect(chef_run).to_not run_ruby_block('apply owncloud config')
    end
  end

  it 'includes cron recipe' do
    expect(chef_run).to include_recipe('cron')
  end

  context 'with cron enabled' do
    before { node.set['owncloud']['cron']['enabled'] = true }

    it 'creates owncloud cron' do
      expect(chef_run).to create_cron('owncloud cron')
        .with_user('www-data')
        .with_minute('*/15')
        .with_hour('*')
        .with_day('*')
        .with_month('*')
        .with_weekday('*')
        .with_command(%r{^php -f .*/cron\.php})
    end
  end # context with cron enabled

  context 'with cron disabled' do
    before { node.set['owncloud']['cron']['enabled'] = false }

    it 'deletes owncloud cron with nginx user' do
      expect(chef_run).to delete_cron('owncloud cron')
        .with_user('www-data')
        .with_command(%r{^php -f .*/cron\.php})
    end
  end

  context 'with skip permissions' do
    before { node.set['owncloud']['skip_permissions'] = true }

    it 'creates apps directory without setting permissions' do
      expect(chef_run).to create_directory('/var/www/owncloud/apps')
        .with_owner(nil)
        .with_group(nil)
        .with_mode(nil)
    end

    it 'creates config directory without setting permissions' do
      expect(chef_run).to create_directory('/var/www/owncloud/config')
        .with_owner(nil)
        .with_group(nil)
        .with_mode(nil)
    end

    it 'creates data directory without setting permissions' do
      expect(chef_run).to create_directory('/var/www/owncloud/data')
        .with_owner(nil)
        .with_group(nil)
        .with_mode(nil)
    end

    it 'creates autoconfig.php file without setting permissions' do
      expect(chef_run).to create_template('owncloud autoconfig.php')
        .with_owner(nil)
        .with_group(nil)
        .with_mode(nil)
    end
  end # context with skip permissions

  context 'with Nginx' do
    before { node.set['owncloud']['web_server'] = 'nginx' }

    it 'includes owncloud::_nginx recipe' do
      expect(chef_run).to include_recipe('owncloud::_nginx')
    end

    context 'on CentOS' do
      let(:chef_runner) do
        ChefSpec::SoloRunner.new(platform: 'centos', version: '6.0')
      end

      it 'creates apps directory with nginx user' do
        expect(chef_run).to create_directory('/var/www/html/owncloud/apps')
          .with_owner('nginx')
          .with_group('nginx')
          .with_mode(00750)
      end

      it 'creates config directory with nginx user' do
        expect(chef_run).to create_directory('/var/www/html/owncloud/config')
          .with_owner('nginx')
          .with_group('nginx')
          .with_mode(00750)
      end

      it 'creates data directory with nginx user' do
        expect(chef_run).to create_directory('/var/www/html/owncloud/data')
          .with_owner('nginx')
          .with_group('nginx')
          .with_mode(00750)
      end

      it 'creates autoconfig.php file with nginx user' do
        expect(chef_run).to create_template('owncloud autoconfig.php')
          .with_owner('nginx')
          .with_group('nginx')
          .with_mode(00640)
      end

      context 'with cron enabled' do
        before { node.set['owncloud']['cron']['enabled'] = true }

        it 'creates owncloud cron with nginx user' do
          expect(chef_run).to create_cron('owncloud cron')
            .with_user('nginx')
        end
      end # context with cron enabled

      context 'with cron disabled' do
        before { node.set['owncloud']['cron']['enabled'] = false }

        it 'deletes owncloud cron with nginx user' do
          expect(chef_run).to delete_cron('owncloud cron')
            .with_user('nginx')
        end
      end
    end # context on CentOS

    context 'autoconfig.php template resource' do
      let(:resource) { chef_run.template('owncloud autoconfig.php') }

      it 'notifies nginx service restart' do
        expect(resource).to notify('service[nginx]').to(:restart).immediately
      end

      it 'notifies nginx service restart' do
        expect(resource).to notify('service[php-fpm]').to(:restart).immediately
      end
    end # context autoconfig.php template resource
  end # context with Nginx

  context 'with unknown web server' do
    before { node.set['owncloud']['web_server'] = 'unknown' }

    it 'raises web server not supported error' do
      expect { chef_run }.to raise_error(/Web server not supported/)
    end
  end # context with unknown web server

  context 'about sendfile' do
    context 'on VirtualBox' do
      before { node.set['virtualization']['system'] = 'vbox' }

      it 'disables sendfile' do
        chef_run
        expect(node['owncloud']['sendfile']).to eq(false)
      end
    end # context on VirtualBox

    context 'on non-VirtualBox virtual environment' do
      before { node.set['virtualization']['system'] = 'other' }

      it 'enables sendfile' do
        chef_run
        expect(node['owncloud']['sendfile']).to eq(true)
      end
    end # context on non-VirtualBox virtual environment

    context 'without virtualization' do
      before { node.set['virtualization'] = false }

      it 'enables sendfile' do
        chef_run
        expect(node['owncloud']['sendfile']).to eq(true)
      end
    end # context without virtualization
  end # context about sendfile
end
