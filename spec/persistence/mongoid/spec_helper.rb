require 'rails_spec_helper'

# use MongoidSetup from fx 
require 'persistence/mongoid/version_setup'

Mongoid.configure do |config|
  Mongoid::VersionSetup.configure config
end

RSpec.configure do |config|
  # config.mock_with(:mocha)

  config.before(:each) do
    Mongoid.purge!
    # Mongoid.database.collections.each do |collection|
    #   unless collection.name =~ /^system\./
    #     collection.remove
    #   end
    # end
  end
end


require 'persistence/spec_helper'

