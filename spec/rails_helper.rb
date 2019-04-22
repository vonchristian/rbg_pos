# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require "money-rails/test_helpers"
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require "pundit/rspec"
require 'webdrivers'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end



RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include Warden::Test::Helpers

  config.after(:each) do
    DatabaseRewinder.clean
  end
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_webdriver
  end
  config.before(:suite) do
      DatabaseRewinder.clean_all
      FactoryBot.reload
    end
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
