source 'https://rubygems.org'

chef_version = ENV.key?('CHEF_VERSION') ? ENV['CHEF_VERSION'] : nil

gem 'berkshelf', '~> 3.0'

group :lint do
  gem 'foodcritic', '~> 3.0'
end

group :unit do
  gem 'chef', chef_version unless chef_version.nil? # Ruby 1.9.3 support
  gem 'should_not', '~> 1.1'
  gem 'chefspec', '~> 4.0'
  gem 'ohai', '~> 7.4' if RUBY_VERSION < '2'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.2'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 0.14'
end

group :kitchen_cloud do
  gem 'kitchen-digitalocean', '~> 0.5'
  gem 'kitchen-ec2', '~> 0.8'
end
