require 'email_center_api'

require 'pry'
require 'fakeweb'
require 'httparty'
require 'json'

RSpec.configure do |config|

  config.before(:all) do
    EmailCenterApi.config_path = File.dirname(__FILE__) + "/support/fake_config.yml"
  end

end




FakeWeb.allow_net_connect = false


#All templates (simplified)
all_templates = [
  {
    text: "email_template",
    children: [
      {text: "A template", nodeId: "10", nodeClass: "email_template"},
      {text: "Another template", nodeId: "11", nodeClass: "email_template"},
      {text: "More templates", nodeId: "12", nodeClass: "email_template"}]
  }
].to_json
FakeWeb.register_uri(:get, 'https://test:test@maxemail.emailcenteruk.com/api/json/tree?method=fetchRoot&tree=email_template&children[]=root',
                     :body => all_templates,
                     :content_type => 'application/json')

#All emails
all_emails = [
  {text: "An email", nodeId: "10", nodeClass: "email"},
  {text: "Another email", nodeId: "11", nodeClass: "email"},
  {text: "More email", nodeId: "12", nodeClass: "email"}
].to_json

FakeWeb.register_uri(:get, 'https://test:test@maxemail.emailcenteruk.com/api/json/tree?method=fetchRoot&tree=email&children[]=root',
                     :body => all_emails,
                     :content_type => 'application/json')
