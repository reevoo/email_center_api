require 'email_center_api'
require 'email_center_api/list'
require 'email_center_api/recipient'
require 'email_center_api/configuration'

require 'fakeweb'
require 'httparty'
FakeWeb.allow_net_connect = false
#Subscribed and Unsubscribed lists
lists_body = "[{\"recipient_id\":\"1234\",\"list_id\":\"25\",\"record_type\":\"campaign\",\"subscribed\":\"0\",\"unsubscribe_method\":\"manual\",\"update_ts\":\"2012-09-11 16:43:10\",\"list_name\":\"testunsub\",\"list_type\":\"suppression\",\"email_address\":\"test@example.co.uk\"},
               {\"recipient_id\":\"1234\",\"list_id\":\"26\",\"record_type\":\"campaign\",\"subscribed\":\"1\",\"update_ts\":\"2012-09-11 16:43:10\",\"list_name\":\"testsublist\",\"list_type\":\"something\",\"email_address\":\"test@example.co.uk\"}]"
FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/recipient?recipientId=1234&method=fetchLists", :body => lists_body, :content_type => "application/json" )
#Subscribed list only
sub_list_body = "[{\"recipient_id\":\"1234\",\"list_id\":\"26\",\"record_type\":\"campaign\",\"subscribed\":\"1\",\"update_ts\":\"2012-09-11 16:43:10\",\"list_name\":\"testsublist\",\"list_type\":\"something\",\"email_address\":\"test@example.co.uk\"}]"
FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/recipient?recipientId=2346&method=fetchLists", :body => sub_list_body, :content_type => 'application/json')
#Find Recipient
recipient_body = "{\"recipient_id\":\"1234\",\"email_address\":\"test@example.co.uk\",\"domain_name\":\"example.co.uk\",\"update_ts\":\"2012-01-21 07:15:13\"}"
FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/recipient?method=find&recipientId=1234", :body => recipient_body, :content_type => "application/json")
#Find another
another_recipient_body = "{\"recipient_id\":\"2346\",\"email_address\":\"test2@example.co.uk\",\"domain_name\":\"example.co.uk\",\"update_ts\":\"2012-01-21 07:15:13\"}"
FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/recipient?method=find&recipientId=2345", :body => another_recipient_body, :content_type => "application/json")

#Recipient not found
recipient_not_found_body = "{\"success\":false,\"msg\":\"Unable to find selected recipient\",\"code\":0,\"errors\":[]}"
FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/recipient?method=find&recipientId=5678", :body => recipient_not_found_body, :content_type => "application/json", :status => 400)
#Find List list
list = '{"list_id":"4","folder_id":"9","name":"Master Unsubscribe List","list_total":"1925","status":"available","type":"suppression","created_ts":"2009-02-13 11:18:05","update_ts":"2012-09-11 13:29:25"}'
FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/list?method=find&listId=4", :body => list, :content_type => "application/json")
#List Not Found
FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/list?method=find&listId=10", :body => '{"success":false,"msg":"Unable to find requested list","code":0,"errors":[]}', :content_type => "application/json", :status => 400)
#All lists
    all_lists = '[{"list_id":"19","folder_id":"9","name":"111116_clicked_bad_link","list_total":"2930","status":"available","type":"include","created_ts":"2011-11-16 17:42:44","update_ts":"2011-11-16 17:43:02"},
                  {"list_id":"21","folder_id":"9","name":"111116_clicked_good_link","list_total":"3602","status":"available","type":"suppression","created_ts":"2011-11-16 17:43:28","update_ts":"2011-11-16 17:43:46"},
                  {"list_id":"23","folder_id":"9","name":"111123_clicked_initial_email","list_total":"23632","status":"available","type":"suppression","created_ts":"2011-11-23 10:02:03","update_ts":"2011-11-23 10:02:28"},
                  {"list_id":"7","folder_id":"9","name":"Contacts","list_total":"0","status":"available","type":"include","created_ts":"2011-08-10 16:23:39","update_ts":"2011-08-10 16:23:39"},
                  {"list_id":"2","folder_id":"9","name":"Master Bounce List","list_total":"4030","status":"available","type":"bounce","created_ts":"2009-02-13 11:18:05","update_ts":"2012-09-11 10:02:15"},
                  {"list_id":"9","folder_id":"33","name":"Master List","list_total":"7521","status":"available","type":"include","created_ts":"2011-08-15 14:50:05","update_ts":"2012-09-11 04:00:15"},
                  {"list_id":"4","folder_id":"9","name":"Master Unsubscribe List","list_total":"1925","status":"available","type":"suppression","created_ts":"2009-02-13 11:18:05","update_ts":"2012-09-11 13:29:25"},
                  {"list_id":"13","folder_id":"33","name":"Reminder List","list_total":"1642205","status":"available","type":"include","created_ts":"2011-10-03 16:22:09","update_ts":"2012-09-11 04:00:15"},
                  {"list_id":"5","folder_id":"9","name":"Test Data (EMC)","list_total":"9","status":"available","type":"include","created_ts":"2011-08-10 14:45:03","update_ts":"2011-08-10 14:48:34"},
                  {"list_id":"11","folder_id":"9","name":"Test Data (SD)","list_total":"3","status":"available","type":"include","created_ts":"2011-08-17 14:14:01","update_ts":"2011-08-17 14:16:48"},
                  {"list_id":"25","folder_id":"9","name":"testunsub","list_total":"0","status":"available","type":"suppression","created_ts":"2012-09-10 13:39:19","update_ts":"2012-09-10 13:39:19"}]'
FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/list?method=fetchAll", :body => all_lists, :content_type => "application/json")

FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/list?method=find&listId=25", :body => "{\"list_id\":\"25\",\"folder_id\":\"9\",\"name\":\"testunsub\",\"list_total\":\"2\",\"status\":\"available\",\"type\":\"suppression\",\"created_ts\":\"2012-09-10 13:39:19\",\"update_ts\":\"2012-09-12 10:23:20\"}", :content_type => "application/json")
FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/list?method=find&listId=26", :body => "{\"list_id\":\"26\",\"folder_id\":\"9\",\"name\":\"tunsublist\",\"list_total\":\"2\",\"status\":\"available\",\"type\":\"something\",\"created_ts\":\"2012-09-10 13:39:19\",\"update_ts\":\"2012-09-12 10:23:20\"}", :content_type => "application/json")

FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/recipient?emailAddress=test%40example.co.uk&method=findByEmailAddress", :body => "1234")
