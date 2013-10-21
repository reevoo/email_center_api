require 'email_center_api'
require 'email_center_api/list'
require 'email_center_api/recipient'
require 'email_center_api/configuration'

require 'pry'
require 'fakeweb'
require 'httparty'





FakeWeb.allow_net_connect = false

#Bad tree in fetchRoot
FakeWeb.register_uri(:get,
                     'https://test:test@maxemail.emailcenteruk.com/api/json/tree?method=fetchRoot&tree=some_root&children[]=root',
                     :body => '{"success":false, "msg":"Invalid Node Class", "code":0, "errors":[]}',
                     :content_type => 'application/json; charset=utf-8')

# Successfull fetchTree
FakeWeb.register_uri(:get, 'https://test:test@maxemail.emailcenteruk.com/api/json/tree?method=fetchTree&tree=email&nodeClass=folder&nodeId=0',
                     :body => '[]',
                     :content_type => 'application/json')

#Bad tree in fetchTree
FakeWeb.register_uri(:get,
                     'https://test:test@maxemail.emailcenteruk.com/api/json/tree?method=fetchTree&tree=some_root&nodeClass=folder&nodeId=0',
                     :body => '{"success":false, "msg":"Invalid Node Class", "code":0, "errors":[]}',
                     :content_type => 'application/json; charset=utf-8')

#All templates (simplified)
all_templates = '[{"text":"email_template",
                  "children":[
                      {"text":"A template",
                       "nodeId":"10",
                       "nodeClass":"email_template"},
                      {"text":"Another template",
                       "nodeId":"11",
                       "nodeClass":"email_template"},
                      {"text":"More templates",
                       "nodeId":"12",
                       "nodeClass":"email_template"}
                  ]
                 }]'
FakeWeb.register_uri(:get, 'https://test:test@maxemail.emailcenteruk.com/api/json/tree?method=fetchRoot&tree=email_template&children[]=root',
                     :body => all_templates,
                     :content_type => 'application/json')

#All emails
all_emails = '[]'


FakeWeb.register_uri(:get, 'https://test:test@maxemail.emailcenteruk.com/api/json/tree?method=fetchRoot&tree=email&children[]=root',
                     :body => all_emails,
                     :content_type => 'application/json')
