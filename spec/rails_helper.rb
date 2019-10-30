# This file is copied to spec/ when you run 'rails generate rspec:install'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rspec'
require 'spec_helper'
# require 'pundit/matchers'
# require 'database_cleaner/active_record'
Dir[Rails.root.join("spec/models/shared_examples/**/*.rb")].each {|f| require f }
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryBot::Syntax::Methods
  config.include Warden::Test::Helpers
  config.example_status_persistence_file_path = "spec/failed_tests.txt"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:each, type: :system) do
    driven_by :rack_test, using: :firefox
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :firefox
  end
  config.before(:suite) do
    DatabaseRewinder.clean_all
  end

  config.after(:each) do
    DatabaseRewinder.clean
  end
end
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
