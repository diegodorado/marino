source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.9'

gem 'mongo'
gem 'mongoid' #must be loaded before cancan
gem 'bson_ext'  #improve MongoDB performance
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'

gem 'devise'
gem "omniauth"
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem "cancan"
gem "rolify"
gem "figaro"

gem "rails_admin"
gem 'axlsx_rails'


gem 'thin'

group :development do
  gem 'quiet_assets'
  gem 'guard-livereload'
  gem "faker"
end

# Gems used only for assets and not required
# in production environments by default.


gem 'twitter-bootstrap-rails', :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git"  #this gem has some helpers
gem 'slickgrid-rails' #, :path => "~/proyectos/gems/slickgrid-rails"

gem 'mongoid-slugify'
gem 'mongoid_commentable'


gem 'coffee-rails', '~> 3.2.1'  #coffee responses are used

group :assets do
  gem 'haml_coffee_assets'
  #gem 'execjs'

  gem "less-rails"
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem "susy"
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer' #, :platforms => :ruby

  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'jquery-plugins-rails'
  gem 'uglifier', '>= 1.0.3'


  gem "js-routes" #, '0.7.4'
  gem "rails-backbone" #, '0.6.1'

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


#required by afip service
#todo: check prawn new versions
gem 'prawn', :git => "git://github.com/sandal/prawn.git", :tag => '0.10.2', :submodules => true
gem 'barby'
gem 'savon'
gem 'httpclient' #used by savon because net_http fallback is failing

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
