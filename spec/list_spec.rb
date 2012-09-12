require 'spec_helper'

describe EmailCenterApi::List do
  before do
    list = '{"list_id":"4","folder_id":"9","name":"Master Unsubscribe List","list_total":"1925","status":"available","type":"suppression","created_ts":"2009-02-13 11:18:05","update_ts":"2012-09-11 13:29:25"}'
    FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/list?method=find&listId=4", :body => list, :content_type => "application/json")
    FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/list?method=find&listId=10", :body => '{"success":false,"msg":"Unable to find requested list","code":0,"errors":[]}', :content_type => "application/json", :status => 0)
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
  end
  describe ".find" do
      it "returns the list with the right id" do
      EmailCenterApi::List.find(4).list_id.should == 4
    end

    it "Throws an exception if the list is not found" do
      expect { EmailCenterApi::List.find(10) }.to raise_error "Api Error: Unable to find requested list"
    end
  end

  describe ".all" do
    it "returns an array" do
      EmailCenterApi::List.all.class.should == Array
    end

    it "should have the correct number of elements" do
      EmailCenterApi::List.all.size.should == 11
    end

    it "has List objects as elements in the array" do
      EmailCenterApi::List.all.first.class.should == EmailCenterApi::List
    end

    it "sets up the list objects with the correct attributes" do
      EmailCenterApi::List.all.first.list_id.should == 19
      EmailCenterApi::List.all.first.status.should == "available"
    end
  end

  describe ".find_by_name" do
    it "should return the correct named list" do
      EmailCenterApi::List.find_by_name("Master Unsubscribe List").list_id.should == 4
    end

    it "should throw an error if the list dosn't exist" do
      expect { EmailCenterApi::List.find_by_name("Stupid Monkey List") }.to raise_error
    end
  end

  describe ".insert_recipient" do
    time = "#{Time.now}"
    email = "james@example.com"
    id = 123456
    FakeWeb.register_uri(:post, "https://test:test@maxemail.emailcenteruk.com/api/json/list?method=insertRecipient", :body => "{\"recipient_id\":\"#{id}\",\"email_address\":\"#{email}\",\"subscribed\":\"0\",\"update_ts\":\"#{time}\"}", :content_type => "application/json")
    options = { :email => email, :subscribed => "0" }

    it "hits the api with the correct post request" do
      EmailCenterApi::Base.stub_chain(:post, :success?).and_return(true)
      EmailCenterApi::Base.stub_chain(:post, :[]).and_return(1)
      EmailCenterApi::Base.should_receive(:post).with("/list", {:body=>{:data=> options, :listId=>25}, :query=>{:method=>"insertRecipient"}})
      EmailCenterApi::List.insert_recipient(25, options)
    end

    it "returns a recipient object" do
      EmailCenterApi::List.insert_recipient(25, options).class.should == EmailCenterApi::Recipient
     end

    it "returns a recipient with the right attributes" do
      EmailCenterApi::List.insert_recipient(25, options).id.should == id
      EmailCenterApi::List.insert_recipient(25, options).email_address.should == email
      EmailCenterApi::List.insert_recipient(25, options).updated_at.should == time
    end

    describe "an instance method .insert_recipient" do
      list = EmailCenterApi::List.new("A List", Time.now.to_s, 123, 14, "Sometype", 25, "A Status", Time.now.to_s)
      it "works in a similar way" do
        list.insert_recipient(options).class.should == EmailCenterApi::Recipient
        list.insert_recipient(options).id.should == id
        list.insert_recipient(options).email_address.should == email
        list.insert_recipient(options).updated_at.should == time
      end
    end
  end
  end
end
