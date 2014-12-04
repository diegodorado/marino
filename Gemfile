source 'https://rubygems.org'
ruby "2.1.2"
gem 'rails', '3.2.9'

gem 'mongo' #, '1.8.0'
#gem 'mongoid', '3.1.1' #must be loaded before cancan
#gem 'bson_ext', '1.8.0'  #improve MongoDB performance

gem 'carrierwave-mongoid', '0.6.1', :require => 'carrierwave/mongoid'
gem 'mongoid-slugify', '0.1.0'
gem 'mongoid_commentable', '0.0.6'

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

gem 'coffee-rails', '~> 3.2.1'  #coffee responses are used

gem 'sass', '3.2.13'
gem 'sass-rails'

group :assets do
  gem 'haml_coffee_assets'
  gem 'bootstrap-sass', '~> 2.3.2.2'
  
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer' #, :platforms => :ruby

  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'jquery-plugins-rails'
  gem 'uglifier', '>= 1.0.3'


  gem "js-routes" #, '0.7.4'
  gem "rails-backbone" , '0.9.0'

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
gem 'prawn' #, :git => "git://github.com/sandal/prawn.git", :tag => '0.10.2', :submodules => true
gem 'barby'
gem 'savon', github: 'savonrb/savon', :branch => "version1"
gem 'httpclient' #used by savon because net_http fallback is failing

