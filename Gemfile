source 'https://rubygems.org'

gem 'rails', '3.2.9'

#gem "rails-settings-cached" ...alternative for mongodb?

gem 'mongo_mapper'
gem 'bson_ext'  #improve MongoDB performance
gem "joint"

gem 'devise'
gem 'mm-devise'
gem "omniauth"
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem "cancan"


gem 'quiet_assets', :group => :development

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "less-rails"
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'

  gem "rails-backbone", :git => 'git://github.com/codebrew/backbone-rails.git'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer' #, :platforms => :ruby

  gem 'twitter-bootstrap-rails'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'

  gem 'uglifier', '>= 1.0.3'
end

gem "haml-rails"

gem "rspec-rails", :group => [:test, :development]
group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem 'spork-rails'
  gem "guard-spork"
  gem "guard-rspec"
  gem "rb-inotify"
  gem 'launchy'
  gem 'database_cleaner' 
end

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
