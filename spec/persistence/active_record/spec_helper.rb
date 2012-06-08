require 'rails_spec_helper'

# Each time recreate test database with migrations
db_dir = Rails.root.join 'test/rails_app/db'
db_file = File.join(db_dir, 'test.sqlite3'
db_migrate_dir = File.join db_dir, 'migrate'

File.delete(db_file) if File.exists?(db_file)
ActiveRecord::Migrator.migrate db_migrate_dir

module RSpec
  def self.orm_configure config
    config.use_transactional_fixtures = true
  end
end

require 'persistence/spec_helper'

