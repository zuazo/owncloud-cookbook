Testing
=======

## Required Gems

* `yard`
* `vagrant`
* `foodcritic`
* `rubocop`
* `berkshelf`
* `should_not`
* `chefspec`
* `test-kitchen`
* `kitchen-vagrant`
* `chef-encrypted-attributes`

### Required Gems for Guard

* `guard`
* `guard-foodcritic`
* `guard-rubocop`
* `guard-rspec`
* `guard-kitchen`

More info at [Guard Readme](https://github.com/guard/guard#readme).

## Installing the Requirements

You must have [VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) installed.

You can install gem dependencies with bundler:

    $ gem install bundler
    $ bundle install --without travis

## Generating the Documentation

    $ bundle exec rake doc

## Running the Syntax Style Tests

    $ bundle exec rake style

## Running the Unit Tests

    $ bundle exec rake unit

## Running the Integration Tests

    $ bundle exec rake integration:vagrant

Or:

    $ bundle exec kitchen list
    $ bundle exec kitchen test
    [...]

### Running Integration Tests in Docker

You need to have [Docker installed](https://docs.docker.com/installation/).

    $ wget -qO- https://get.docker.com/ | sh

Then use the `integration:docker` rake task to run the tests:

    $ bundle exec rake integration:docker

### Running Integration Tests in the Cloud

#### Requirements

* `kitchen-digitalocean`
* `kitchen-ec2`

You can run the tests in the cloud instead of using vagrant. First, you must set the following environment variables:

* `AWS_ACCESS_KEY_ID` (See [`kitchen-ec2` gem documentation](https://github.com/test-kitchen/kitchen-ec2#authenticating-with-aws)).
* `AWS_SECRET_ACCESS_KEY` (See [`kitchen-ec2` gem documentation](https://github.com/test-kitchen/kitchen-ec2#authenticating-with-aws)).
* `AWS_SSH_KEY_ID`: EC2 SSH public key name. This is the name used in Amazon EC2 Console's Key Pars section (See [`kitchen-ec2` gem documentation](https://github.com/test-kitchen/kitchen-ec2#authenticating-with-aws)).
* `DIGITALOCEAN_ACCESS_TOKEN` (See [`kitchen-digitalocean` gem documentation](https://github.com/test-kitchen/kitchen-digitalocean#installation-and-setup)).
* `DIGITALOCEAN_SSH_KEY_IDS`: DigitalOcean SSH numeric key IDs (See [`kitchen-digitalocean` gem documentation](https://github.com/test-kitchen/kitchen-digitalocean#installation-and-setup)).
* `SSH_KEY_PATH`: EC2 SSH private key local full path. Only when you are not using an SSH Agent.

Then use the `integration:cloud` rake task to run the tests:

    $ bundle exec rake integration:cloud

## Using Vagrant with the Vagrantfile

### Vagrantfile Requirements

* ChefDK: https://downloads.chef.io/chef-dk/
* Berkhelf and Omnibus vagrant plugins:
```
$ vagrant plugin install vagrant-berkshelf vagrant-omnibus
```
* The path correctly set for ChefDK:
```
$ export PATH="/opt/chefdk/bin:${PATH}"
```
### Vagrantfile Usage

    $ vagrant up

To run Chef again on the same machine:

    $ vagrant provision

To destroy the machine:

    $ vagrant destroy
