require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)

HOST = ENV['MONGOID_SPEC_HOST'] || 'localhost'
PORT = ENV['MONGOID_SPEC_PORT'] || '27017'
DATABASE = 'mongoid_lazy_migration_test'

Mongoid.configure do |config|
  config.connect_to(DATABASE)
end

RSpec.configure do |config|
  config.before(:each) do
    Mongoid.purge!
  end
end
