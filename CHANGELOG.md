# CHANGELOG for owncloud

This file is used to list changes made in each version of `owncloud`.

## v1.0.0 (2015-10-08)

### Upgrading from a `0.x.y` Cookbook Release

***Note:*** Please do this with caution. Make a full backup before upgrading.

If you want to upgrade the cookbook version from a `0.x` release, you should change the MySQL data directory to the old path (or migrate the database by hand):

```ruby
node.default['owncloud']['mysql']['data_dir'] = '/var/lib/mysql'
# [...]
include_recipe 'owncloud'
```

### Breaking Changes on v1.0.0

* Use [`mysql`](https://supermarket.chef.io/cookbooks/mysql) cookbook version `6` ([issue #21](https://github.com/zuazo/owncloud-cookbook/pull/21), thanks [@avsh](https://github.com/avsh)) ([#bd4eba9](https://github.com/zuazo/owncloud-cookbook/commit/bd4eba9d26186baa3d3033b52449aedbf62e4bf8), [#22a2a4f](https://github.com/zuazo/owncloud-cookbook/commit/22a2a4f3fa9d6bd26598324298e6e9effa086b8a), [#f686605](https://github.com/zuazo/owncloud-cookbook/commit/f686605339db550a249bd79f8a8c306c9938617d), [#33a393c](https://github.com/zuazo/owncloud-cookbook/commit/33a393cf871c489d8282338e4fe8e0e71da9760c), [#f7d467d](https://github.com/zuazo/owncloud-cookbook/commit/f7d467db71082f4e4f465bac271f2f3434815052), [#0e63402](https://github.com/zuazo/owncloud-cookbook/commit/0e63402b8a059c449d67591a43ae26e832088bb9), [#5f04c62](https://github.com/zuazo/owncloud-cookbook/commit/5f04c622da3990cb25c04c7666fd9961d90ce21d), [#778211d](https://github.com/zuazo/owncloud-cookbook/commit/778211d22afb9c8a56123ae86438ddb4903b0d68)).
* Requires **Chef `11.14.2`**.
* Drop Ruby `1.9.3` support (required by foodcritic `5`): **Ruby `2` required** ([#952caa4](https://github.com/zuazo/owncloud-cookbook/commit/952caa46506db776a44bf49465058f9454f17345)).
* Drop Ubuntu `10.04` support ([EOL reached](http://fridge.ubuntu.com/2015/04/30/ubuntu-10-04-lucid-lynx-end-of-life-reached-on-april-30-2015/)) ([#a7ad0c3](https://github.com/zuazo/owncloud-cookbook/commit/a7ad0c383cd8f3dc3970d1aca6415fc4298f9fdb)).
* Improve some old platforms support (**installs old ownCloud versions on those platforms**) ([#b3dc45e](https://github.com/zuazo/owncloud-cookbook/commit/b3dc45ec6174efb76b8ae5b6e13a11804180b18a), [#afeb353](https://github.com/zuazo/owncloud-cookbook/commit/afeb35334323024077444bdf72bd8f913bdb9e29), [#cf48390](https://github.com/zuazo/owncloud-cookbook/commit/cf48390e15f503078d66b005d0573d2e899b4a10), [#336c270](https://github.com/zuazo/owncloud-cookbook/commit/336c2706d065abf1c22989e8944e5c19df5f06b4)):
  * Debian `6`.
  * CentOS `6`.

### New Features on v1.0.0

* Add Ubuntu `15.04` support ([#eb328b6](https://github.com/zuazo/owncloud-cookbook/commit/eb328b6b50cf8083d93225e05aa8fac8ed7e58fe), [#2d42783](https://github.com/zuazo/owncloud-cookbook/commit/2d427837099db02bd332b2bbb5ad5d15525a5e3e), [#d43a45b](https://github.com/zuazo/owncloud-cookbook/commit/d43a45b2c120c3f3e764ae40e7ad390b0dc9f5bc)).
* Add Scientific Linux support ([#f91ce0a](https://github.com/zuazo/owncloud-cookbook/commit/f91ce0a8d4cb3dd612b170d111e0002a1b1bfb55)).
* Support non standard database ports ([issue #22](https://github.com/zuazo/owncloud-cookbook/pull/22), thanks [Michael Sprauer](https://github.com/MichaelSp)) ([#7cdb4be](https://github.com/zuazo/owncloud-cookbook/commit/7cdb4beb07f73ace9936776a1845e4942071c13d), [#772844c](https://github.com/zuazo/owncloud-cookbook/commit/772844cf2180ae66f359bc03875642c666c5196e), [#7f9ce9c](https://github.com/zuazo/owncloud-cookbook/commit/7f9ce9c59f152c6e5f0d134d5570e7e1c12bd3d2), [#661b706](https://github.com/zuazo/owncloud-cookbook/commit/661b7062cdbac2de151cd6fb19cf2193ef372a39), [#170358e](https://github.com/zuazo/owncloud-cookbook/commit/170358ef0b0e322e69e9594ed59605acb0d1e2c5)).
* Use [`ssl_certificate`](https://supermarket.chef.io/cookbooks/ssl_certificate) cookbook for the HTTPS certificate (requires Chef `11.14.2`, apart from that, it should be backward compatible) ([#f08b336](https://github.com/zuazo/owncloud-cookbook/commit/f08b33620cc3f994a0d3735c44fc573753eb02ba), [#ed8ec74](https://github.com/zuazo/owncloud-cookbook/commit/ed8ec744aa077fc7d2267acbce11e0d826659cb6), [#214c57b](https://github.com/zuazo/owncloud-cookbook/commit/214c57b0c7b4b8a1100689622bebd8a029a0559c), [#65ebf38](https://github.com/zuazo/owncloud-cookbook/commit/65ebf38f00b72572140a16f384c357ed59f1808e)).
* Generate download URL dynamically using the version value ([#553307a](https://github.com/zuazo/owncloud-cookbook/commit/553307ad4310bfd7d4c9f5565fa07dc76faa111d)).
* Add `node['owncloud']['manage_database']` attribute ([#7fd36c7](https://github.com/zuazo/owncloud-cookbook/commit/7fd36c7ee62cd477735d82dc5a0aea69d4d1290c)).
* Encrypt some attributes with [`chef-encrypted-attributes`](http://onddo.github.io/chef-encrypted-attributes/) gem ([#acb190e](https://github.com/zuazo/owncloud-cookbook/commit/acb190eedfa1d577972f395421b5fa4fc5f14c9e)).
* Move packages to install to node attributes ([#17af639](https://github.com/zuazo/owncloud-cookbook/commit/17af6394a5f3780a9c82ef59496fd09be4f915a9)).
* Add a Dockerfile ([#489e379](https://github.com/zuazo/owncloud-cookbook/commit/489e379d0ae652ae1fb6ba70e52388ba7758a503)).

### Fixes on v1.0.0

* Install crontab: Fixes a CentOS error ([#7181d5a](https://github.com/zuazo/owncloud-cookbook/commit/7181d5a8a5d9f52b04ed39e509176e82fb3d5eb9)).
* `OwncloudCookbook::Config` library: Escape JSON backslash and quotes for PHP ([#4941aea](https://github.com/zuazo/owncloud-cookbook/commit/4941aea170398190e83cdd103d7a012eb335c341)).
* Fix `postgresql_database_user[owncloud]` resource duplication ([#70e48e6](https://github.com/zuazo/owncloud-cookbook/commit/70e48e691d207cd575f32369579064deb917fa10)).

### Improvements on v1.0.0

* Remove `#deep_to_hash` method (requires Chef `11.12`) ([#cadff9e](https://github.com/zuazo/owncloud-cookbook/commit/cadff9e7d193a8a47f1c560df469605ba043a154)).
* Use `fail` instead of `Chef::Application.fatal!` ([#2fcf112](https://github.com/zuazo/owncloud-cookbook/commit/2fcf1124255e649377b044b6ff56c2c76340d771)).
* Fix all RuboCop offenses (big refactor) ([#aa08214](https://github.com/zuazo/owncloud-cookbook/commit/aa08214845674f49fea2d3e110085a816d4d4bfc)).
* Move the `ruby_block[apply config]` logic to a library, including tests ([#e20824b](https://github.com/zuazo/owncloud-cookbook/commit/e20824b7c213ce9ffaf86340b1594dd23dbb2897)).
* Fix the last foodcritic offenses ([#bafd29b](https://github.com/zuazo/owncloud-cookbook/commit/bafd29b5f4014a125caf5426bda0b5bfdad66820), [#8cca6f9](https://github.com/zuazo/owncloud-cookbook/commit/8cca6f9a62065539b09900522c6e30412e0d6702), [#a6839d4](https://github.com/zuazo/owncloud-cookbook/commit/a6839d44e34f7e3a6650ff3b9e999b20e4cfa074)).
* Use `node['platform_family']` to improve platforms support ([#1e2ede8](https://github.com/zuazo/owncloud-cookbook/commit/1e2ede8b1dd506c3eac3662ab2af3d279a69513d)).
* Do not use `node#override` ([#60c46c1](https://github.com/zuazo/owncloud-cookbook/commit/60c46c176b65bf78e8ef0669a8d3516a7e53dca9)).
* Use `Chef::Log` instead of `log` resource ([#9fd7783](https://github.com/zuazo/owncloud-cookbook/commit/9fd77835d3858ffb85056666f94eae444e69ea76)).
* Rename some resources to avoid name collisions ([#0665b0f](https://github.com/zuazo/owncloud-cookbook/commit/0665b0f34c502c1ce36c0e404fe5de010352367c)).
* Use `node['owncloud']['config']['dbhost']` attribute for the local database connections ([#3269e9f](https://github.com/zuazo/owncloud-cookbook/commit/3269e9f11f21e316dfea062ba3916875cdf22b71)).
* Improve errors checking during ownCloud setup ([#561cdec](https://github.com/zuazo/owncloud-cookbook/commit/561cdeca52421fc45cde096701e51116e7db1a31), [#7a439b7](https://github.com/zuazo/owncloud-cookbook/commit/7a439b74518a07b6564e9a6610de558ed3007c5a)).
* Improve disabling nginx default site ([#8df835f](https://github.com/zuazo/owncloud-cookbook/commit/8df835f71e17e2e45b55acddf06ce2ef2a76b787)).
* Improve PostgreSQL support on Debian platform family ([#22d7d2c](https://github.com/zuazo/owncloud-cookbook/commit/22d7d2c836f0fec13489aacc9ec0101178985027), [#bc40c7f](https://github.com/zuazo/owncloud-cookbook/commit/bc40c7f1cb25ec9c82ac700817ac9d5087c81b5e)).

### Documentation Changes on v1.0.0

* Document all the libraries ([#42339d7](https://github.com/zuazo/owncloud-cookbook/commit/42339d70dd3f96e1d1673d143a99293325878a03), [#c70544e](https://github.com/zuazo/owncloud-cookbook/commit/c70544e772960b29570f2108c6fb3e1aa86d6d7c)).
* metadata:
  * Improve cookbook description ([#843fcb4](https://github.com/zuazo/owncloud-cookbook/commit/843fcb47ec439da33ee0ec5ea82820f7fd18cdc5)).
  * Add `source_url` and `issues_url` links ([#e43ddf2](https://github.com/zuazo/owncloud-cookbook/commit/e43ddf258c58a6b2a5a01bdedde072a7229c6f82)).
* Documentation updated, improved and separated into multiple files ([#505a194](https://github.com/zuazo/owncloud-cookbook/commit/505a19412667c9b9c6d780d09b718431d04a18bb), [#fcc69a7](https://github.com/zuazo/owncloud-cookbook/commit/fcc69a7b95340aea6cad08c83cfab8209f6487dc), [#575a180](https://github.com/zuazo/owncloud-cookbook/commit/575a180755f422287ee75a34fe11c853f58feaa6)).
* README:
  * Use markdown tables ([#9ce3513](https://github.com/zuazo/owncloud-cookbook/commit/9ce351360ec529a2cfc4eb6a843a69d66a4d7c8f)).
  * Add a supported platforms table ([#57466af](https://github.com/zuazo/owncloud-cookbook/commit/57466afbbe64d26eaea66ba3ce903b3bacf46d2b), [#295c901](https://github.com/zuazo/owncloud-cookbook/commit/295c9015ee1c0643d4571614a1358a4260dd2405)).
  * Improve PostgreSQL documentation and tests ([#e6b050b](https://github.com/zuazo/owncloud-cookbook/commit/e6b050b79d6ecddf56e175e4df79f9b8c2213a9c), [#44c4631](https://github.com/zuazo/owncloud-cookbook/commit/44c463147f34b9dd6e94d0afd4bc5f246fef1afb)).
  * Improve the title and the description ([#b48ea3d](https://github.com/zuazo/owncloud-cookbook/commit/b48ea3d66bb5b85cae5169ecea10894d810e47cc)).
  * Add some missing contributors ([#4f65371](https://github.com/zuazo/owncloud-cookbook/commit/4f653715eeea1652eb6d53441248de323491f4b5)).
  * Complete License and Author section ([#21499c1](https://github.com/zuazo/owncloud-cookbook/commit/21499c1f7c9a75b058e3cde8c8f53abcc44f6b2f)).
  * Add Coveralls badge ([#a8b3ff1](https://github.com/zuazo/owncloud-cookbook/commit/a8b3ff1f57c4a515b98ab8317a49187744b60740)).
  * Add Code Climate badge ([#a6657a0](https://github.com/zuazo/owncloud-cookbook/commit/a6657a07e0144e0d5e91745a44d0b56c9bff5fc8)).
  * Add GitHub badge ([#378c2ac](https://github.com/zuazo/owncloud-cookbook/commit/378c2ac034eaad3c2352339f40be02dddb451efb)).
  * Add Gemnasium badge ([#5787e71](https://github.com/zuazo/owncloud-cookbook/commit/5787e717b22376eca413c981d3c068d88129b660), [#56ef7db](https://github.com/zuazo/owncloud-cookbook/commit/56ef7db15c59f5f3535862b998813633f9a69ea1)).
  * Update chef links to use *chef.io* domain ([#45f040f](https://github.com/zuazo/owncloud-cookbook/commit/45f040fe76183576a963a05b0a09997d2af88d5d)).
  * Update contact information and links after migration ([#c8a9176](https://github.com/zuazo/owncloud-cookbook/commit/c8a917633c5a1abac13e6c0c02dc1d5cd7c4c4f9)).
* Add LICENSE file ([#f5189ae](https://github.com/zuazo/owncloud-cookbook/commit/f5189ae1792fcaab16a3daa05e7fe944d90c7dcc)).
* Add license headers ([#93a2c71](https://github.com/zuazo/owncloud-cookbook/commit/93a2c710ff5fb0301763a332414b32c1af1f2c61)).

### Changes on Tests on v1.0.0

* Add ChefSpec unit tests ([#f3ec28e](https://github.com/zuazo/owncloud-cookbook/commit/f3ec28e2516019b93f6fd46eb0ba1ff89fae157e), [#44de096](https://github.com/zuazo/owncloud-cookbook/commit/44de0962b42118688651fff5b6fafd2dcd2f11fb), [#cf68608](https://github.com/zuazo/owncloud-cookbook/commit/cf68608bcf450b9d0ca362dab669778055b5cf00), [#bee15cc](https://github.com/zuazo/owncloud-cookbook/commit/bee15cc1e32c9584a5e8b231979aabb3973368d6), [#e0445b6](https://github.com/zuazo/owncloud-cookbook/commit/e0445b6e995dc40a7e489c8ff7ea6acf58cdc8f9), [#244a729](https://github.com/zuazo/owncloud-cookbook/commit/244a7295ebf0b9aa318ab9ae81db7517a0eb8f3d), [#7110fa7](https://github.com/zuazo/owncloud-cookbook/commit/7110fa7d3d776d69eb52ed2080ee7c117d21e2c4)).
* Add RSpec unit tests to the `OwncloudCookbook::Config` library ([#807e9dc](https://github.com/zuazo/owncloud-cookbook/commit/807e9dce95bec3c1c034c38e7606a8c0e4f8124a)).
* Enable Travis CI ([#533986c](https://github.com/zuazo/owncloud-cookbook/commit/533986c89aca08dca31511cd342b759c0b53e4df)).
* Run test-kitchen on Travis CI using native Docker support ([#1cddd6a](https://github.com/zuazo/owncloud-cookbook/commit/1cddd6ac12485fbecd27670c4d9d2bf298430527), [#0d13191](https://github.com/zuazo/owncloud-cookbook/commit/0d131917c4dcf5463dcc991d8c5bf1be3c41b020)).
* Add a Guardfile ([#b818c3f](https://github.com/zuazo/owncloud-cookbook/commit/b818c3f290ab230cb5b82bdcb00c30533f6a6b9e)).
* Update the *.gitignore* file ([#04f81d6](https://github.com/zuazo/owncloud-cookbook/commit/04f81d66a82a6307976f8e4b0d96cd2a9c0d4606)).
* Integration tests:
  * Move *test/kitchen/cookbooks* to *test/cookbooks* ([#f6fd48f](https://github.com/zuazo/owncloud-cookbook/commit/f6fd48f3075d413d9524efc1c9f5494b05c559cb)).
  * Disable SELinux in integration tests ([#263576f](https://github.com/zuazo/owncloud-cookbook/commit/263576fcb9756e257ef26550e407fb19c2177be2)).
  * .kitchen.yml: Update platform versions ([#ab3684c](https://github.com/zuazo/owncloud-cookbook/commit/ab3684c8ce2029b161f1b5fdb7b215c48b0b8d44), [#286f3ce](https://github.com/zuazo/owncloud-cookbook/commit/286f3ce232bd263e229c8104d9df684b2746bd52), [#c61b18c](https://github.com/zuazo/owncloud-cookbook/commit/c61b18c028e69bdd74d01fede47f7571d40771be)).
  * Update some testing related files: Berksfile, Gemfile, Rakefile ([#b0acf6d](https://github.com/zuazo/owncloud-cookbook/commit/b0acf6d5c3f54b36c6042d12e675cbf27883ce95)).
  * Remove database port integration tests ([#85ef251](https://github.com/zuazo/owncloud-cookbook/commit/85ef2515b2613b1d57ed9939db2460248e17d48a)).
  * Replace bats test by Serverspec tests ([#491d5c0](https://github.com/zuazo/owncloud-cookbook/commit/491d5c03899226b46b18bbee8ac8f076b90a1352), [#e897ad2](https://github.com/zuazo/owncloud-cookbook/commit/e897ad26a694a55816dcfdd0f76b2f50a7f29514), [#06bbda9](https://github.com/zuazo/owncloud-cookbook/commit/06bbda9cb916ded3df493506f3bbdb37f8c07c60)).
  * Add *emailtest.php* template for ownCloud `8.1` ([#fb46d71](https://github.com/zuazo/owncloud-cookbook/commit/fb46d71856fde35d0f758ac91cf1f9c310dab996)).
  * Install ownCloud version `8.0` while [owncloud/core#19110](https://github.com/owncloud/core/issues/19110) is fixed ([#7fdf123](https://github.com/zuazo/owncloud-cookbook/commit/7fdf12354c2d2c34ea161a59a0dfbf0a6b102fd9)).
  * Save generated passwords correctly ([#57f0d6d](https://github.com/zuazo/owncloud-cookbook/commit/57f0d6dc98fe73dce8316efb0b17c067dc62af21)).
  * Improve `owncloud_test` cookbook description ([#99c1694](https://github.com/zuazo/owncloud-cookbook/commit/99c1694722316654d9161c4827eb5f1b8ec54c06)).
  * Run integration tests on Docker (*.kitchen.docker.yml*) ([#da0d9bb](https://github.com/zuazo/owncloud-cookbook/commit/da0d9bb8633389e7b4346402900a65e96ee7673c)).
  * Update *.kitchen.cloud.yml* file ([#5299b22](https://github.com/zuazo/owncloud-cookbook/commit/5299b223a3a480a1a2efc33080b14df8376c57f2)).

## v0.5.0 (2015-04-08)

* Lock cookbook versions on metadata.
* Add option to skip setting permissions (issues [#18](https://github.com/zuazo/owncloud-cookbook/issues/18) and [#20](https://github.com/zuazo/owncloud-cookbook/pull/20), thanks [LEDfan](https://github.com/LEDfan)).
* Install PHP `5.4` repo on Ubuntu `<= 12.04` ([issue #19](https://github.com/zuazo/owncloud-cookbook/issues/19), thanks [Jason Boyles](https://github.com/JasonBoyles) for reporting).
* Run setup from the command line rather than HTTP request.
* Add web services restart again, required by some SSL setups.
* metadata: Update `openssl` cookbook to version `4` ([issue #22](https://github.com/zuazo/owncloud-cookbook/issues/22), thanks [LEDfan](https://github.com/LEDfan) for reporting).

## v0.4.2 (2014-12-12)

* metadata: Lock to `mysql` cookbook `~> 5.0`.

## v0.4.1 (2014-11-27)

* Fix Apache httpd `2.4` support: fixes CentOS 7 and Ubuntu 14 support ([issue #16](https://github.com/zuazo/owncloud-cookbook/issues/16), thanks [@LEDfan](https://github.com/LEDfan) for reporting).
* README:
 * Update readme about updates ([issue #17](https://github.com/zuazo/owncloud-cookbook/pull/17), thanks [@cvl-skubriev](https://github.com/cvl-skubriev)).
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
* Fixed compatibility issue with Chef 11.8 due to a bug on http_request resource ([CHEF-4762](https://tickets.chef.io/browse/CHEF-4762))
* Fixed issue when upgrading from previous ownCloud installation

## v0.2.0 (2013-09-13)

* Nginx supported as web server
* ownCloud deployable from git

## v0.1.0 (2013-08-07)

* Initial release of `owncloud`
