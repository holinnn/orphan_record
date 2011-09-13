require 'rubygems'
require 'bundler/setup'
require 'spork'


Spork.prefork do
  require 'active_record'
  require 'rspec'
  require 'logger'
  require 'orphan_record'


  require File.join(File.dirname(__FILE__), '/support/models')

  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation

  ActiveRecord::Base.logger = Logger.new(STDOUT)

  I18n.config.load_path << File.join(File.dirname(__FILE__), '/support/orphan_record.en.yml')

  RSpec.configure do |config|
    config.before :all do
      ModelMigrations.up unless ActiveRecord::Base.connection.table_exists?('users')
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  Dir["#{File.dirname(__FILE__)}/../lib/**/*.rb"].each { |f| load f }

  load "#{File.dirname(__FILE__)}/support/models.rb"
end
