source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

gem 'mysql2'#, '0.3.12b4'
gem 'haml'#, '3.1.7'

gem 'nokogiri' #xml parser/reader I use for .mzIdentML files


#tablas bonitas
gem 'jquery-datatables-rails', git: 'git://github.com/rweng/jquery-datatables-rails.git'
gem 'ajax-datatables-rails'

#D3.js is a JavaScript library for manipulating documents based on data. Interactive graphics and stuff
gem 'd3js-rails'


#server side datatables processing
gem 'will_paginate'


#For behavior driven development we add rspec-rails and factory_girl_rails
group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl_rails', '~> 4.0'
end

#For integration testing capybara together with guard
group :test do #these are grouped under test bc are only used when actually running specs
  gem 'faker' #generates random data in combination with factory_girl
  gem 'shoulda-matchers' #allows to test associations like this: " it { should belong_to(:experiment) }
  gem 'capybara', '~>2.0.2'
  gem 'guard'
  gem 'guard-rspec'
  gem 'growl'
end
#guard and guard-rspec for automatic testing, watches changes to files and performs tests


# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

#Compass with support for rails 4
#gem 'compass-rails', github: 'milgner/compass-rails', branch: 'rails4'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails' #trae estilos y demas

#friendly_id e facilita el uso del nombre del modelo en la URL sin tener que poner el id como prefijo. URLS mas informativas.
gem 'friendly_id', :require => 'friendly_id'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', :require => "bcrypt"

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
