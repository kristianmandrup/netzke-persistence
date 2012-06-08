# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../test/rails_app/config/environment", __FILE__)
require 'rspec/rails'

if RUBY_VERSION >= '1.9.2'
  YAML::ENGINE.yamler = 'syck'
end
