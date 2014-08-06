require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)

HOST = ENV['MONGOID_SPEC_HOST'] || 'localhost'
PORT = ENV['MONGOID_SPEC_PORT'] || '27017'
DATABASE = 'mongoid_lazy_migration_test'

Mongoid.configure do |config|
  if Mongoid::LazyMigration.mongoid3
    config.connect_to(DATABASE)
    ::BSON = ::Moped::BSON
  else
    database = Mongo::Connection.new(HOST, PORT.to_i).db(DATABASE)
    config.master = database
    config.logger = nil
  end
end

RSpec.configure do |config|
  config.mock_with :mocha
  config.color_enabled = true

  config.before(:each) do
  if Mongoid::LazyMigration.mongoid3
      Mongoid.purge!
    else
      Mongoid.database.collections.each do |collection|
        unless collection.name.include?('system')
          collection.remove
        end
      end
    end
    Mongoid::IdentityMap.clear
  end
end

def insert_raw(type, fields={})
  id = BSON::ObjectId.new
  type.collection.insert({:_id => id}.merge(fields))
  id
end
