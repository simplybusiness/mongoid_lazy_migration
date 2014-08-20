source 'https://rubygems.org'
gemspec

ENV['MONGOID_VERSION'] ||= '4.0.0'

group :test do
  gem 'rake'
  gem 'mongoid', "~> #{ENV['MONGOID_VERSION']}"
  gem 'rspec'
  gem 'mocha', :require => false
  gem 'pry-plus'
end
