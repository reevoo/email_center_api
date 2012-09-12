require 'spec_helper'

describe EmailCenterApi::List do
  describe ".find" do
      it "returns the list with the right id" do
      EmailCenterApi::List.find(4).id.should == 4
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
      EmailCenterApi::List.all.first.id.should == 19
      EmailCenterApi::List.all.first.status.should == "available"
    end
  end

  describe ".find_by_name" do
    it "should return the correct named list" do
      EmailCenterApi::List.find_by_name("Master Unsubscribe List").id.should == 4
    end

    it "should throw an error if the list dosn't exist" do
      expect { EmailCenterApi::List.find_by_name("Stupid Monkey List") }.to raise_error
    end
  end

  describe ".insert_recipient" do
    time = "#{Time.now}"
    email = "james@example.com"
    id = 123456
    FakeWeb.register_uri(:post, "https://test:test@maxemail.emailcenteruk.com/api/json/list", :body => "{\"recipient_id\":\"#{id}\",\"email_address\":\"#{email}\",\"subscribed\":\"0\",\"update_ts\":\"#{time}\"}", :content_type => "application/json; charset=utf-8")
    options = { :email => email, :subscribed => "0" }

    it "hits the api with the correct post request" do
      EmailCenterApi::Base.stub_chain(:post, :success?).and_return(true)
      EmailCenterApi::Base.stub_chain(:post, :[]).and_return(1)
      EmailCenterApi::Base.should_receive(:post).with("/list", {:body=>{:data=> options, :listId=>25, :method=>"insertRecipient"}})
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

  describe ".delete_recipient" do
    it "hits the api with the correct post request" do
      EmailCenterApi::Base.stub_chain(:post, :success?).and_return(true)
      EmailCenterApi::Base.should_receive(:post).with("/list", {:body=>{:recipientId=> 1234, :listId=>25, :method=>"deleteRecipient"}})
      EmailCenterApi::List.delete_recipient(25,1234)
    end

    it "returns true if the recipient was removed from the list" do
      FakeWeb.register_uri(:post, "https://test:test@maxemail.emailcenteruk.com/api/json/list", :body => "true", :content_type => "application/json; charset=utf-8")
      EmailCenterApi::List.delete_recipient(25,1234)
    end

    it "throws an error if the recipient dosn't exist on the list" do
      FakeWeb.register_uri(:post, "https://test:test@maxemail.emailcenteruk.com/api/json/list", :body => "{\"success\":false,\"msg\":\"Unable to find requested list recipient\",\"code\":0,\"errors\":[]}", :content_type => "application/json; charset=utf-8", :status => 400)
      expect { EmailCenterApi::List.delete_recipient(25,1234) }.to raise_error "Api Error: Unable to find requested list recipient"
    end

    it "has an instance method that accepts a recipient object" do
      list = EmailCenterApi::List.new("A List", Time.now.to_s, 123, 14, "Sometype", 25, "A Status", Time.now.to_s)
      EmailCenterApi::Base.stub_chain(:post, :success?).and_return(true)
      EmailCenterApi::Base.should_receive(:post).with("/list", {:body=>{:recipientId=> 1234, :listId=>25, :method=>"deleteRecipient"}})
      recipient = EmailCenterApi::Recipient.new(1234,"something@whatever.com",Time.now.to_s)
      list.delete_recipient(recipient)
    end
  end

  describe ".recipients" do
    id = rand(10000)
    id2 = rand(10000)
    recipients = "{\"list_total\":\"2\",\"count\":2,\"offset\":\"0\",\"limit\":\"100\",\"sort\":\"email_address\",\"dir\":\"ASC\",\"records\":[{\"record_type\":\"campaign\",\"subscribed\":\"0\",\"unsubscribe_method\":\"manual\",\"update_ts\":\"2012-09-11 16:43:10\",\"recipient_id\":\"#{id}\",\"email_address\":\"testing@exam41313ple123245.com\",\"Default.Date of Birth\":null,\"Default.EmailAddress\":null,\"Default.First Name\":null,\"Default.Gender\":null,\"Default.Last Name\":null,\"Default.Location\":null,\"Reviews.Country\":null,\"Reviews.product_image\":null,\"Reviews.purchase_date\":null,\"Reviews.questionnaire_no\":null,\"Reviews.questionnaire_short\":null,\"Reviews.questionnaire_yes\":null,\"Reviews.retailer_from\":null,\"Reviews.retailer_image\":null,\"Reviews.retailer_name\":null,\"Reviews.retailer_privacy_link\":null,\"Reviews.retailer_product_name\":null,\"Reviews.retailer_terms_conditions\":null,\"Reviews.retailer_website\":null,\"Reviews.subject\":null,\"Reviews.tracking_image\":null,\"Reviews.unsubscribe_link\":null,\"Reviews.variant\":null,\"Sent.FirstReview\":null},{\"record_type\":\"campaign\",\"subscribed\":\"1\",\"unsubscribe_method\":null,\"update_ts\":\"2012-09-11 16:26:09\",\"recipient_id\":\"#{id2}\",\"email_address\":\"testing@example.com\",\"Default.Date of Birth\":null,\"Default.EmailAddress\":null,\"Default.First Name\":null,\"Default.Gender\":null,\"Default.Last Name\":null,\"Default.Location\":null,\"Reviews.Country\":null,\"Reviews.product_image\":null,\"Reviews.purchase_date\":null,\"Reviews.questionnaire_no\":null,\"Reviews.questionnaire_short\":null,\"Reviews.questionnaire_yes\":null,\"Reviews.retailer_from\":null,\"Reviews.retailer_image\":null,\"Reviews.retailer_name\":null,\"Reviews.retailer_privacy_link\":null,\"Reviews.retailer_product_name\":null,\"Reviews.retailer_terms_conditions\":null,\"Reviews.retailer_website\":null,\"Reviews.subject\":null,\"Reviews.tracking_image\":null,\"Reviews.unsubscribe_link\":null,\"Reviews.variant\":null,\"Sent.FirstReview\":null}]}"
    FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/list?dir=ASC&filter[]=email_address&limit=100&listId=25&start=0&method=fetchRecipients&sort=email_address", :body => recipients, :content_type => "application/json; charset=utf-8")
    list = EmailCenterApi::List.new("A List", Time.now.to_s, 123, 14, "Sometype", 25, "A Status", Time.now.to_s)

    it "returns an array of the recipients in the list" do
      list.recipients.first.class.should == EmailCenterApi::Recipient
      list.recipients.first.id.should == id
      list.recipients.last.id.should == id2
      list.recipients.first.email_address.should == "testing@exam41313ple123245.com"
    end

  end
end
