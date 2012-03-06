This is a small gem which an application running on a Cloud Foundry instance can use to access their environment.
If the application is not running on Cloud Foundry then all methods will return nil so its easy to provide an alternate configuration.

## Installation

### Command Line
```bash
gem install cloudfoundry-env
```

### Gemfile

``` ruby
gem "cloudfoundry-env","~> 0.0.2", :require => "cloudfoundry/environment"
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
