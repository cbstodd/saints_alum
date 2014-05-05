source 'https://rubygems.org'

ruby '2.1.1'

gem 'rails', '3.2.16'

gem 'bootstrap-sass-rails', '~> 3.1.0.0'

gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate'
gem 'jquery-rails'
gem 'redcarpet'

group :development, :test do
  gem 'sqlite3', '1.3.8'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-theme'

end

# Gems used only for assets and not required
# in production environments by default.
group :assets do

  gem 'coffee-rails'
  gem 'uglifier', '2.1.1'
end

group :test do
  gem 'capybara'
  gem 'factory_girl_rails', '4.1.0'
  gem 'cucumber-rails', '1.2.1', :require => false
  gem 'database_cleaner', '0.7.0'
  # gem 'launchy', '2.1.0'
  # gem 'rb-fsevent', '0.9.1', :require => false
  # gem 'growl', '1.0.3'
end

group :production do
  gem 'pg', '0.12.2'
  gem 'rails_12factor', '0.0.2'
end
