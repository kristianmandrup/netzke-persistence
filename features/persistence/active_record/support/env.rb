module Netzke
  module Persistence
    module CucumberConfig
      def self.set_dummy_app_env!
        require Rails.root.join 'test/rails_app/config/environment'
      end

      def self.orm_config!
        require 'cucumber/rails/active_record'
      end

      def self.post_config!
        Cucumber::Rails::World.use_transactional_fixtures = true
        # How to clean your database when transactions are turned off. See
        # http://github.com/bmabey/database_cleaner for more info.
        if defined?(ActiveRecord::Base)
          begin
            require 'database_cleaner'
            ::DatabaseCleaner.strategy = :truncation
          rescue LoadError => ignore_if_database_cleaner_not_present
          end
        end
      end        
    end
  end
end

require 'support/env'
