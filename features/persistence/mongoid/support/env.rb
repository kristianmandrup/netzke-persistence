module Netzke
  module Persistence
    module CucumberConfig
      def self.set_dummy_app_env!
        require Rails.root.join 'test/mongoid_rails_app/config/environment'
      end

      def self.orm_config!
        require 'cucumber/rails/mongoid'
      end

      def self.post_config!
        # uses Mongoid.purge! after each spec example?
      end        
    end
  end
end

require 'support/env'
