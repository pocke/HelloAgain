# require 'pry'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

MODELS = File.join(File.dirname(__FILE__), 'models')
SUPPORT = File.join(File.dirname(__FILE__), 'support')
$LOAD_PATH.unshift(MODELS)
$LOAD_PATH.unshift(SUPPORT)

if ENV['CI']
  # require "simplecov"
  require 'coveralls'
  Coveralls.wear!
  # SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  # SimpleCov.start do
  #  add_filter "spec"
  # end
end

require 'pry'
require 'rspec'
require 'mongoid'
# require "mocha"
require 'mongoid/geospatial'

LOGGER = Logger.new($stdout)

Mongoid.configure do |config|
  config.connect_to('mongoid_geo_test')
end

# Autoload every model for the test suite that sits in spec/app/models.
Dir[File.join(MODELS, '*.rb')].sort.each do |file|
  name = File.basename(file, '.rb')
  autoload name.camelize.to_sym, name
end

Dir[File.join(SUPPORT, '*.rb')].each { |file| require File.basename(file) }

RSpec.configure do |config|
  # config.mock_with(:mocha)

  config.before(:each) do
    Mongoid.purge!
  end
end

Mongo::Logger.logger.level = Logger::INFO if Mongoid::VERSION >= '5'

# Mongoid.load!(File.expand_path('../support/mongoid.yml', __FILE__), :test)

puts "Running with Mongoid v#{Mongoid::VERSION}"
