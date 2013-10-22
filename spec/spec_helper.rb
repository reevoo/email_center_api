$LOAD_PATH << './'
require 'email_center_api'

require 'pry-debugger' unless ENV['RM_INFO']
require 'fakeweb'
require 'httparty'
require 'json'

RSpec.configure do |config|

  config.before(:all) do
    EmailCenterApi.config_path = File.dirname(__FILE__) + "/support/fake_config.yml"
  end

end

FakeWeb.allow_net_connect = false

Dir['spec/fake_web_helpers/*.rb'].each { |f| require f }
