This is a small gem which an application running on a Cloud Foundry instance can use to access their environment.
If the application is not running on Cloud Foundry then all methods will return nil so its easy to provide an alternate configuration.

## Installation

### Command Line
```bash
gem install cloudfoundry-env
```

### Gemfile

``` ruby
gem "cloudfoundry-env","~> 0.0.5", :require => "cloudfoundry/environment"
```

## Usage

#### Listening on the proper HTTP port

``` ruby
configure do
  set(:port, CloudFoundry::Environment.port || 4567)
end
```

#### Connecting to a service

``` ruby
@redis = Redis.new(CloudFoundry::Environment.redis_cnx || {host: "127.0.0.1", port: "6379"})
```

#### Conditional logic for multiple instances of an app

``` ruby
# The new wordpress path
@blog_rss = "#{@blog}/post/category/announcement/feed"

freq = 60 + (60 * 5 * (CloudFoundry::Environment.instance_index || 0))

@blog_feed = CloudFoundry::Feed.new(@blog_rss, @redis, crawl_frequency: freq)

```

## CloudFoundry::Environment Methods

* host - Return a string with the host ip address or nil if not running on cloud
* port - Returns integer with port number
* instance_index - Returns integer with instance index starting at 1
* running_local? - returns `true` if the app is not running on a CloudFoundry instance
* is_prod_app?(regex) - Returns `true` if the app name starts with regex provided. Good for having staging and prod apps
* first_url - Returns the first url for the app or nil
* app_info - returns the entire environment described by VCAP_APPLICATION


* services - Returns a Hashie::Mash representation of the services so it can be used as a class with native attributes
  * Cloud Foundry Services - http://start.cloudfoundry.com/services.html
  * Hashie - https://github.com/intridea/hashie
* [service_name]_cnx - Returns a Hashie::Mash representation of only the credentials for a service. Example from rspec test:

```ruby
cf = CloudFoundry::Environment
cf.redis_cnx.port.should == 5076
cf.redis_cnx.host.should == "172.30.48.40"
cf.redis_cnx.password.should == "49badd9d-40a9-aaa-4e8fcdc15a75"
```

* [service_name]_info - Returns a Hashie::Mash representation of the service. Example from rspec test:

``` ruby
cf = CloudFoundry::Environment
cf.mongo_info.name.should == "mongodb-78564"
cf.mongo_info.credentials.port.should == 25084
cf.mongo_cnx.host.should == "172.30.48.64"
cf.mongo_cnx.db.should == "db"
cf.mongo_cnx.username.should == "1aaca416-fb89-4a08-8b7b-3d022ef3c44b"
cf.mongo_cnx.password.should == "7ea3c7ab-bd10-4ff9-8131-50d951b5863f"
```


