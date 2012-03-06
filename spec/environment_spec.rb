require_relative "spec_helper"

describe "CloudFoundry::Environment" do

  it "Should recognize when its not running on Cloud Foundry" do
    cf = CloudFoundry::Environment
    cf.port.should be_nil
    cf.running_local?.should be_true
    cf.raw_app_version.should be_nil
    cf.redis_cnx.should be_nil
  end

  it "should recognize when its running on Cloud Foundry" do
    ENV["VCAP_APP_PORT"] = "9456"
    ENV["VCAP_APPLICATION"]  = load_fixture("vcap_application.json")

    cf = CloudFoundry::Environment
    cf.port.should == 9456
    cf.running_local?.should be_false
    cf.raw_uris.should include "www-newstage2.cloudfoundry.com"
    cf.is_prod_app?.should be_false
    cf.raw_app_version.should == "a38cf47787b08a8f3d9316fccfaeaeac4282df2e-1"
  end

  it "should detect a prod app" do
     ENV["VCAP_APPLICATION"]  = load_fixture("vcap_application_prod.json")

     cf = CloudFoundry::Environment
     cf.running_local?.should be_false
     cf.raw_uris.should include "www2.cloudfoundry.com"
     cf.is_prod_app?.should be_true
   end

  it "should find the redis service" do
    ENV["VCAP_SERVICES"] = load_fixture("vcap_services_redis.json")

    cf = CloudFoundry::Environment
    cf.redis_cnx.port.should == 5076
    cf.redis_cnx.host.should == "172.30.48.40"
    cf.redis_cnx.password.should == "49badd9d-40a9-aaa-4e8fcdc15a75"
  end

  it "should not find the redis service if running locally" do
    ENV["VCAP_SERVICES"] = nil
    CloudFoundry::Environment.redis_cnx.should be_nil
  end

  it "should not find the redis service if not present" do
    ENV["VCAP_SERVICES"] = load_fixture("vcap_services.json")
    CloudFoundry::Environment.redis_cnx.should be_nil
  end

  it "should find the mongodb service" do
    ENV["VCAP_SERVICES"] = load_fixture("vcap_all_services.json")

    cf = CloudFoundry::Environment
    cf.mongo_info.name.should == "mongodb-78564"
    cf.mongo_info.credentials.port.should == 25084
    cf.mongo_cnx.host.should == "172.30.48.64"
    cf.mongo_cnx.db.should == "db"
    cf.mongo_cnx.username.should == "1aaca416-fb89-4a08-8b7b-3d022ef3c44b"
    cf.mongo_cnx.password.should == "7ea3c7ab-bd10-4ff9-8131-50d951b5863f"
  end

  it "should find the mysql service" do
    ENV["VCAP_SERVICES"] = load_fixture("vcap_all_services.json")
    cf = CloudFoundry::Environment
    cf.mysql_cnx.user.should == "u5qXCmDCGwNjF"
  end

  it "should return nil for services which dont exist" do
    ENV["VCAP_SERVICES"] = load_fixture("vcap_all_services.json")
    cf = CloudFoundry::Environment
    cf.newrelic_cnx.should == nil
    cf.mysql_cnx(1).should == nil
  end
end