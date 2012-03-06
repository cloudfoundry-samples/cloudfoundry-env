require "rubygems"
require "sinatra"
require "rest-client"

get "/services.json" do
  ENV["VCAP_SERVICES"]
end

get "/env.json" do
  ENV[params[:name]] if params[:name]
end

get "/dave" do
  RestClient.get "http://dsyerstatic.cloudfoundry.com/uaa.yml"
end