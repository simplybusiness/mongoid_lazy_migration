namespace :db do
  namespace :mongoid do
    desc <<-HEREDOC
      Migrate the documents specified by criteria. criteria is optional

      Simple Example:
        be rake db:mongoid:lazy_migrate[Model]
      More advanced example:
        be rake db:mongoid:lazy_migrate["Model.where(:created_at => '2014-04-01'.to_date..Date.tomorrow)"]
    HEREDOC
    task :lazy_migrate, [:criteria] => :environment do |t, args|
      criteria = args.criteria ? eval(args.criteria) : nil
      Mongoid::LazyMigration.migrate(criteria)
    end

    desc 'Cleanup a migration'
    task :cleanup_migration, [:model] => :environment do |t, args|
      raise "Please provide a model" unless args.model
      Mongoid::LazyMigration.cleanup(eval(args.model))
    end

    desc <<-HEREDOC
      Reset object's migration_state to pending, requires: Model name and object's id.

      It can happen that migration block will raise an error, or the process that runs migraiton
      stop, and leave the object in the processing state. To proceed we need to reset that state to pending, so the
      next time the object is loaded it will perform migraion.
    HEREDOC
    task :reset_state, [:model, :model_id] => :environment do |t, args|
      raise "Please provide a model" unless args.model
      raise "Please provide a object's id" unless args.model_id
      Mongoid::LazyMigration.reset_state(eval(args.model), args.model_id)
    end
  end
end
