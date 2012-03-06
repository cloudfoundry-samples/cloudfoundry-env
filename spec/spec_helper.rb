require "rspec"
require_relative "../lib/cloudfoundry/environment"

def load_fixture(filename)
  File.read("#{File.dirname(__FILE__)}/fixtures/#{filename}")
end
