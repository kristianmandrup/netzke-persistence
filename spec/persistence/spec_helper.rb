# Somehow the following is needed
# FactoryGirl.find_definitions
require 'factory_girl'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
support_files = Dir[File.dirname(__FILE__) + "/../../spec/support/**/*.rb"]

puts "support_files: #{support_files}"

support_files.each do |f| 
  puts "require: #{f}"
  require f
end

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  RSpec.orm_configure(config) if RSpec.respond_to?(:orm_configure)
end
