source 'https://rubygems.org'
ruby '2.6.3'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.2.3'
gem 'rubyzip', '>= 1.2.1'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: 'c8ac844'
gem 'axlsx_rails'
gem 'pghero'
gem 'chronic'
gem 'pg_query', '>= 0.9.0'
gem "spreadsheet"
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7', group: [:development, :production]
gem 'sass-rails', '>= 3.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 3.0'
gem 'devise'
gem 'simple_form'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'sassc-rails', '>= 2.1.0'
gem 'icheck-rails'
gem 'friendly_id'
gem 'font-awesome-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap-datepicker-rails'
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
gem 'dragonfly'
gem 'pg_search'
gem 'paperclip'
gem 'avatar_magick', '~> 1.0.1'
gem 'pundit'
gem 'prawn'
gem 'prawn-table'
gem "gretel"
gem 'public_activity'
gem 'mina-puma', require: false
gem 'barby'
gem 'prawn-print'
gem 'simple-line-icons-rails'
gem 'select2-rails'
gem 'rqrcode'
gem 'dotiw'
gem 'will_paginate', '~> 3.1.0'
gem "chartkick"
gem "groupdate"
gem "roo", "~> 2.7.0"

group :development do
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'bullet'
  gem 'listen'
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8.0'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-its'

end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem "launchy"
  gem 'webdrivers', '~> 3.0'
  gem 'database_rewinder'
end
gem 'rack-mini-profiler'
gem 'flamegraph'
gem 'stackprof'
gem 'memory_profiler'

gem 'whenever', :require => false
