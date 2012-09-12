require 'spec_helper'

describe EmailCenterApi::Recipient do
  describe ".find" do
    recipient_body = "{\"recipient_id\":\"1234\",\"email_address\":\"test@example.co.uk\",\"domain_name\":\"example.co.uk\",\"update_ts\":\"2012-01-21 07:15:13\"}"
    FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/recipient?method=find&recipientId=1234", :body => recipient_body, :content_type => "application/json")
    recipient_not_found_body = "{\"success\":false,\"msg\":\"Unable to find selected recipient\",\"code\":0,\"errors\":[]}"
    FakeWeb.register_uri(:get, "https://test:test@maxemail.emailcenteruk.com/api/json/recipient?method=find&recipientId=5678", :body => recipient_not_found_body, :content_type => "application/json", :status => 400)
    it 'returns a recipient with the correct id' do
      EmailCenterApi::Recipient.find(1234).id.should == 1234
    end

    it 'returns a recipient with the correct params' do
      EmailCenterApi::Recipient.find(1234).email_address.should == "test@example.co.uk"
      EmailCenterApi::Recipient.find(1234).updated_at.should == "2012-01-21 07:15:13"
    end

    it 'rases an error if the id is not found' do
      expect { EmailCenterApi::Recipient.find(1234) }
    end
  end
end
