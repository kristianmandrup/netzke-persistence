module Netzke
  module Persistence
    class Engine < ::Rails::Engine
    end
  end
end

require 'netzke/persistence/component_state_mixin'