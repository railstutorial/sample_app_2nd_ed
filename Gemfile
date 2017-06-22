source 'https://rubygems.org'
gem "rails", '~>4.0.0'

gem 'protected_attributes' # https://github.com/rails/protected_attributes
gem 'activeresource' # https://github.com/rails/activeresource
gem 'actionpack-action_caching' # https://github.com/rails/actionpack-action_caching
gem 'activerecord-session_store' # https://github.com/rails/activerecord-session_store
gem 'rails-observers' # https://github.com/rails/rails-observers

gem 'rake', '12.0.0'
gem 'bootstrap-sass', '2.1'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate'
gem 'bootstrap-will_paginate', '0.0.6'
gem 'jquery-rails'
gem 'rubyzip'
gem 'zip'

group :development, :test do
  gem 'sqlite3', '~>1.3.5'
  gem 'rspec-rails' #, '2.99.0'
  gem 'guard-rspec' #, '3.1.0'
  gem 'guard-livereload'
  gem 'spork-rails' #, github: 'sporkrb/spork-rails' # rubygems version not rails 4 compatible
  gem 'guard-spork' #, '2.1.0'
  gem 'childprocess' #, '0.3.6'
  gem 'spork' #, '0.9.2'
  gem 'minitest' #, '4.7.5'
  gem 'test-unit' #, '3.2.4'
  gem 'rspec-its'
end

# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails',   '4.0.0'
gem 'coffee-rails', '4.0.0'
gem 'uglifier', '1.2.3'


group :test do
  gem 'selenium-webdriver', '2.0.0'
  gem 'capybara' #, '2.1.0'
  gem 'factory_girl_rails' #, '4.1.0'
  gem 'cucumber', '1.2.5'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner' #, '0.7.0'
  # gem 'launchy', '2.1.0'
  # gem 'rb-fsevent', '0.9.1', :require => false
  # gem 'growl', '1.0.3'
  gem 'simplecov', :require => false
end

group :production do
  gem 'pg', '0.12.2'
end
