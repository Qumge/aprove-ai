source 'https://rubygems.org'

ruby '4.0.1'

# Rails 8 keeps this legacy app on Sprockets while the app still uses
# `//= require`, CoffeeScript assets, and SCSS asset helpers.
gem 'rails', '~> 8.1.3'
gem 'sprockets-rails', '~> 3.5'
gem 'dartsass-sprockets', '~> 3.2'
gem 'coffee-rails', '~> 5.0'
gem 'jbuilder', '~> 2.14'
gem 'puma', '>= 6.6', '< 8'
gem 'turbolinks', '~> 5.2'
gem 'terser', '~> 1.2'

# PostgreSQL is the supported database for local development, test, and production.
gem 'pg', '>= 1.5', '< 2'

# UI assets
gem 'jquery-rails', '~> 4.6'
gem 'jquery-ui-rails', '>= 8.0', '< 9'
gem 'jquery-inputmask-rails', '~> 2.5'
gem 'jquery-knob-rails', '~> 1.2'
gem 'jquery-datatables-rails', '~> 3.4'
gem 'bootstrap-sass', '~> 3.4'
gem 'bootstrap-datepicker-rails', '>= 1.10', '< 2'
gem 'bootstrap-timepicker-rails', '~> 0.1'
gem 'bootstrap-colorpicker-rails', '~> 0.4'
gem 'font-awesome-rails', '~> 4.7'
gem 'ionicons-rails', '~> 2.0'
gem 'lucide-rails', '~> 0.7.4'
gem 'icheck-rails', '~> 1.0'
gem 'morris.js-rails', '~> 1.0'
gem 'flot-rails', '~> 0.0'
gem 'sparkline', '~> 0.1'
gem 'select2-rails', '~> 4.0'
gem 'fullcalendar-rails', '~> 3.9'
gem 'momentjs-rails', '>= 2.29', '< 3'
gem 'fastclick-rails', '~> 1.0'

# App features
gem 'devise', '~> 5.0'
gem 'rails_admin', '~> 3.3'
gem 'paper_trail', '~> 17.0'
gem 'cancancan', '~> 3.6'
gem 'ancestry', '~> 4.3'
gem 'simple_form', '~> 5.3'
gem 'kaminari', '~> 1.2'
gem 'kaminari-bootstrap', '~> 3.0'
gem 'config', '>= 5.0'
gem 'aws-sdk-s3', '~> 1.200'
gem 'bower-rails', '~> 0.12'
gem 'aasm', '~> 5.5'
gem 'paranoia', '~> 3.0'
gem 'china_city'
gem 'active_importer'
gem 'rest-client', '~> 2.1'
gem 'whenever', require: false
gem 'exception_notification', '~> 5.0'

group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'debug', '>= 1.10'
  gem 'mina', '~> 1.2'
end

group :development do
  gem 'web-console', '~> 4.2'
end
