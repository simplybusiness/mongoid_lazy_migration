module Mongoid::LazyMigration::Tasks
  def migrate(criteria=nil)
    require 'ruby-progressbar'

    criterias = criteria.nil? ? Mongoid::LazyMigration.models_to_migrate : [criteria]

    criterias.each do |criteria|
      to_migrate = criteria.where(:migration_state.ne => :done).batch_size(50)
      progress = ProgressBar.create title: to_migrate.klass.to_s, total: to_migrate.count

      to_migrate.each_with_index do |o, i|
        progress.increment
        sleep 0.07 if i % 100 == 0
      end
    end
    true
  end

  def cleanup(model)
    if model.in? Mongoid::LazyMigration.models_to_migrate
      raise "Remove the migration from your model before cleaning up the database"
    end

    # @todo: the migration_state is not indexed, wouldn't this query kill DB?
    if model.where(:migration_state => :processing).limit(1).count > 0
      raise ["Some models are still being processed.",
             "Remove the migration code, and go inspect them with:",
             "#{model}.where(:migration_state => :processing))",
             "Don't forget to remove the migration block"].join("\n")
    end

    selector = { :migration_state => { "$exists" => true }}
    changes  = {"$unset" => { :migration_state => 1}}

    model.where(selector).update_all(changes)
  end
end
