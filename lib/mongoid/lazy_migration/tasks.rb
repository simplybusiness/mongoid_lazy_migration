module Mongoid::LazyMigration::Tasks
  def migrate(criteria=nil)
    require 'progressbar'

    criterias = criteria.nil? ? Mongoid::LazyMigration.models_to_migrate : [criteria]

    criterias.each do |criteria|
      to_migrate = criteria.where(:migration_state.ne => :done).batch_size(50)
      progress = ProgressBar.new(to_migrate.klass.to_s, to_migrate.count)
      progress.long_running

      to_migrate.each_with_index do |o, i|
        progress.inc
        sleep 0.07 if i % 100 == 0
      end

      progress.finish
    end
    true
  end

  def cleanup(model)
    if model.in? Mongoid::LazyMigration.models_to_migrate
      raise "Remove the migration from your model before cleaning up the database"
    end

    if model.where(:migration_state => :processing).limit(1).count > 0
      raise ["Some models are still being processed.",
             "Remove the migration code, and go inspect them with:",
             "#{model}.where(:migration_state => :processing))",
             "Don't forget to remove the migration block"].join("\n")
    end

    selector = { 'migration_state' => {'$in' => ['done']} }

    # The design goal behind this is to have as little impact on the production system.
    # That's why we don't make a single query that updates all matching fields, although we would have to test it.
    model.
      collection.
      find(selector).
      select('_id' => 1).
      batch_size(500).
      each_with_index.
      each do |document, index|
        model.collection.find(_id: document["_id"]).update_all(
          { "$unset" => { "migration_state" => "" } }
        )
    end
  end
end
