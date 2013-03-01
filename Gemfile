source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.9'

#gem "rails-settings-cached" ...alternative for mongodb?

gem 'mongoid' #must be loaded before cancan
gem 'bson_ext'  #improve MongoDB performance
gem "grid_attachment"

gem 'devise'
gem "omniauth"
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem "cancan"

gem "rails_admin"

group :development do
  gem 'quiet_assets'
  gem 'thin'
end

# Gems used only for assets and not required
# in production environments by default.


gem 'twitter-bootstrap-rails', :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git" #this gem has some helpers
gem 'slickgrid-rails' #, :path => "~/proyectos/gems/slickgrid-rails"

group :assets do
  gem "less-rails"
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer' #, :platforms => :ruby

  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'jquery-plugins-rails'
  
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
