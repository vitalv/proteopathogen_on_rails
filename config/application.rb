require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module ProteopathogenOnRails
  class Application < Rails::Application
    
    #This part is the content of class Application as default in a new rails 4 app:
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    
    #And this next part is remaining from the proteopathogen_on_rails_3 app

    # Configure the default encoding used in templates for Ruby 1.9.a
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    #configure my test framework
    config.generators do |g|
      g.test_framework :rspec, 
        fixtures: true, #specifies to generate a fixture for each model (using a Factory Girl factory, instead of an actual fixture) 
        view_specs: false, #don't want view specs, instead use request specs to test interface elements
        helper_specs: false, #false por ahora
        routing_specs: false, #omits a spec file for config/routes.rb
        controller_specs: true, 
        request_specs: false #set request_specs false, bc I want to do integration test with capybara features
      g.fixtures_replacement :factory_girl, dir: "spec/factories" #tells rails to generate factories instead of fixtures and save in spec/factories
    end
        
  end
end
