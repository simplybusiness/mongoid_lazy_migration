namespace :db do
  namespace :mongoid do
    desc 'Migrate the documents specified by criteria. criteria is optional'
    task :lazy_migrate, [:criteria] => :environment do |t, args|
      criteria = args.criteria ? eval(args.criteria) : nil
      Mongoid::LazyMigration.migrate(criteria)
    end

    desc 'Cleanup a migration'
    task :cleanup_migration, [:model] => :environment do |t, args|
      raise "Please provide a model" unless args.model
      Mongoid::LazyMigration.cleanup(eval(args.model))
    end

    desc "Reset the migration_state, requires: Model name and object's id"
    task :reset_state, [:model, :model_id] => :environment do |t, args|
      raise "Please provide a model" unless args.model
      raise "Please provide a object's id" unless args.model_id
      Mongoid::LazyMigration.reset_state(eval(args.model), args.model_id)
    end
  end
end
