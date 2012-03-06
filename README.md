This is a small gem which an application running on a Cloud Foundry instance can use to access their environment.
It the application is not running on Cloud Foundry then everything will return nil.

## Gemfile

``` bash
gem "cloudfoundry-env","~> 0.0.2", :require => "cloudfoundry/environment"
```

## Usage

#### Listening on the proper port
``` ruby
configure do
  set(:port, CloudFoundry::Environment.port || 4567)
end
```

#### Configuring a service

``` ruby
@redis = Redis.new(CloudFoundry::Environment.redis_cnx || LOCAL_REDIS)
```


#### Conditional logic for multiple instances of an app

``` ruby
 # The new wordpress path
    @blog_rss = "#{@blog}/post/category/announcement/feed"
    @cf_jobs_rss = "http://jobs.vmware.com/feeds/#{@job_search_term}/?src=RSS"

    freq = 60 + (60 * 5 * (CloudFoundry::Environment.instance_index || 0))

    @blog_feed = CloudFoundry::Feed.new(@blog_rss, @redis,
      crawl_frequency: freq)
    @job_feed = CloudFoundry::JobFeed.new(@cf_jobs_rss, @redis,
      crawl_frequency: freq * 2)
```
