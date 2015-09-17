<?php
$CONFIG = array (
  'instanceid' => '',
  'passwordsalt' => '',
  'hashingCost' => 10,
  'trusted_domains' => 
  array (
    0 => 'demo.example.org',
    1 => 'otherdomain.example.org',
  ),
  'datadirectory' => '/var/www/owncloud/data',
  'version' => '',
  'dbtype' => 'sqlite',
  'dbhost' => '',
  'dbname' => 'owncloud',
  'dbuser' => '',
  'dbpassword' => '',
  'dbtableprefix' => '',
  'dbdriveroptions' => 
  array (
    1012 => '/file/path/to/ca_cert.pem',
  ),
  'sqlite.journal_mode' => 'DELETE',
  'installed' => false,
  'default_language' => 'en',
  'defaultapp' => 'files',
  'knowledgebaseenabled' => true,
  'enable_avatars' => true,
  'allow_user_to_change_display_name' => true,
  'remember_login_cookie_lifetime' => 1296000,
  'session_lifetime' => 86400,
  'session_keepalive' => true,
  'skeletondirectory' => '/path/to/owncloud/core/skeleton',
  'user_backends' => 
  array (
    0 => 
    array (
      'class' => 'OC_User_IMAP',
      'arguments' => 
      array (
        0 => '{imap.gmail.com:993/imap/ssl}INBOX',
      ),
    ),
  ),
  'mail_domain' => 'example.com',
  'mail_from_address' => 'owncloud',
  'mail_smtpdebug' => false,
  'mail_smtpmode' => 'sendmail',
  'mail_smtphost' => '127.0.0.1',
  'mail_smtpport' => 25,
  'mail_smtptimeout' => 10,
  'mail_smtpsecure' => '',
  'mail_smtpauth' => false,
  'mail_smtpauthtype' => 'LOGIN',
  'mail_smtpname' => '',
  'mail_smtppassword' => '',
  'overwritehost' => '',
  'overwriteprotocol' => '',
  'overwritewebroot' => '',
  'overwritecondaddr' => '',
  'overwrite.cli.url' => '',
  'proxy' => '',
  'proxyuserpwd' => '',
  'trashbin_retention_obligation' => 30,
  'trashbin_auto_expire' => true,
  'appcodechecker' => true,
  'updatechecker' => true,
  'has_internet_connection' => true,
  'check_for_working_webdav' => true,
  'check_for_working_htaccess' => true,
  'config_is_read_only' => false,
  'log_type' => 'owncloud',
  'logfile' => 'owncloud.log',
  'loglevel' => 2,
  'log.condition' => 
  array (
    'shared_secret' => '57b58edb6637fe3059b3595cf9c41b9',
    'users' => 
    array (
      0 => 'sample-user',
    ),
    'apps' => 
    array (
      0 => 'files',
    ),
  ),
  'logdateformat' => 'F d, Y H:i:s',
  'logtimezone' => 'Europe/Berlin',
  'log_query' => false,
  'cron_log' => true,
  'cron.lockfile.location' => '',
  'log_rotate_size' => false,
  '3rdpartyroot' => '',
  '3rdpartyurl' => '',
  'customclient_desktop' => 'http://owncloud.org/sync-clients/',
  'customclient_android' => 'https://play.google.com/store/apps/details?id=com.owncloud.android',
  'customclient_ios' => 'https://itunes.apple.com/us/app/owncloud/id543672169?mt=8',
  'appstoreenabled' => true,
  'appstoreurl' => 'https://api.owncloud.com/v1',
  'appstore.experimental.enabled' => false,
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/owncloud/apps',
      'url' => '/apps',
      'writable' => true,
    ),
  ),
  'enable_previews' => true,
  'preview_max_x' => 2048,
  'preview_max_y' => 2048,
  'preview_max_scale_factor' => 10,
  'preview_max_filesize_image' => 50,
  'preview_libreoffice_path' => '/usr/bin/libreoffice',
  'preview_office_cl_parameters' => ' --headless --nologo --nofirststartwizard --invisible --norestore -convert-to pdf -outdir ',
  'enabledPreviewProviders' => 
  array (
    0 => 'OC\\Preview\\PNG',
    1 => 'OC\\Preview\\JPEG',
    2 => 'OC\\Preview\\GIF',
    3 => 'OC\\Preview\\BMP',
    4 => 'OC\\Preview\\XBitmap',
    5 => 'OC\\Preview\\MP3',
    6 => 'OC\\Preview\\TXT',
    7 => 'OC\\Preview\\MarkDown',
  ),
  'ldapUserCleanupInterval' => 51,
  'maintenance' => false,
  'singleuser' => false,
  'openssl' => 
  array (
    'config' => '/absolute/location/of/openssl.cnf',
  ),
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'memcache.distributed' => '\\OC\\Memcache\\Memcached',
  'redis' => 
  array (
    'host' => 'localhost',
    'port' => 6379,
    'timeout' => 0,
    'dbindex' => 0,
  ),
  'memcached_servers' => 
  array (
    0 => 
    array (
      0 => 'localhost',
      1 => 11211,
    ),
  ),
  'cache_path' => '',
  'objectstore' => 
  array (
    'class' => 'OC\\Files\\ObjectStore\\Swift',
    'arguments' => 
    array (
      'username' => 'facebook100000123456789',
      'password' => 'Secr3tPaSSWoRdt7',
      'container' => 'owncloud',
      'autocreate' => true,
      'region' => 'RegionOne',
      'url' => 'http://8.21.28.222:5000/v2.0',
      'tenantName' => 'facebook100000123456789',
      'serviceName' => 'swift',
    ),
  ),
  'supportedDatabases' => 
  array (
    0 => 'sqlite',
    1 => 'mysql',
    2 => 'pgsql',
    3 => 'oci',
  ),
  'blacklisted_files' => 
  array (
    0 => '.htaccess',
  ),
  'share_folder' => '/',
  'theme' => '',
  'cipher' => 'AES-256-CFB',
  'minimum.supported.desktop.version' => '1.7.0',
  'quota_include_external_storage' => false,
  'filesystem_check_changes' => 1,
  'asset-pipeline.enabled' => false,
  'assetdirectory' => '/var/www/owncloud',
  'mount_file' => 'data/mount.json',
  'filesystem_cache_readonly' => false,
  'secret' => '',
  'trusted_proxies' => 
  array (
    0 => '203.0.113.45',
    1 => '198.51.100.128',
  ),
  'forwarded_for_headers' => 
  array (
    0 => 'HTTP_X_FORWARDED',
    1 => 'HTTP_FORWARDED_FOR',
  ),
  'max_filesize_animated_gifs_public_sharing' => 10,
  'filelocking.enabled' => false,
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'copied_sample_config' => true,
);
