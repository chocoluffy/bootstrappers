require 'rails/generators'
require 'rails/generators/rails/app/app_generator'


module Bootstrapers
  class AppGenerator < Rails::Generators::AppGenerator

    class_option :database, :type => :string, :aliases => '-d', :default => 'mysql',
      :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    def finish_template
      invoke :bootstrapers_customization
      super
    end

    def bootstrapers_customization
      invoke :remove_files_we_dont_need
      invoke :setup_development_environment
      invoke :create_bootstrapers_views
      invoke :create_common_javascripts
      invoke :add_jquery_ui
      invoke :customize_gemfile
      invoke :setup_database
    end

    def remove_files_we_dont_need
      build :remove_public_index
      build :remove_rails_logo_image
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :raise_delivery_errors
    end

    def create_bootstrapers_views
      say 'Creating bootstrapers views'
      build :create_partials_directory
      build :create_application_layout
    end

    def create_common_javascripts
      say 'Pulling in some common javascripts'
      build :create_common_javascripts
    end

    def add_jquery_ui
      say 'Add jQuery ui to the standard application.js'
      build :add_jquery_ui
    end

    def customize_gemfile
      build :add_custom_gems
      bundle_command 'install'
    end

    def setup_database
      say 'Setting up database'

      if 'mysql' == options[:database]
        build :use_mysql_config_template
      end

      build :create_database
    end

    protected

    def get_builder_class
      Bootstrapers::AppBuilder
    end

  end
end
