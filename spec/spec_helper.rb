require "mongoid"

Mongoid::Config.connect_to("mongoid_lazy_migration_test")

RSpec.configure do |config|
  config.before(:each) do
    Mongoid.purge!
  end
end

current_path = File.expand_path("..", __FILE__)
require File.join(current_path, "..", "lib", "mongoid_lazy_migration")
