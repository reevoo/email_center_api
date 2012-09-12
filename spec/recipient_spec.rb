require 'spec_helper'

describe EmailCenterApi::Recipient do
  describe ".find" do
    it 'returns a recipient with the correct id' do
      EmailCenterApi::Recipient.find(1234).id.should == 1234
    end

    it 'returns a recipient with the correct params' do
      EmailCenterApi::Recipient.find(1234).email_address.should == "test@example.co.uk"
      EmailCenterApi::Recipient.find(1234).updated_at.should == "2012-01-21 07:15:13"
    end

    it 'rases an error if the id is not found' do
      expect { EmailCenterApi::Recipient.find(5678) }.to raise_error "Api Error: Unable to find selected recipient"
    end
  end

  describe ".unsubscribed_from" do
    it "returns all the lists where subscribed == 0" do
      EmailCenterApi::Recipient.find(1234).unsubscribed_from.first.id.should == 25
    end
  end

  describe ".unsubscribed?" do
    it "returns true if the recipient is unsubscribed from somthing" do
      EmailCenterApi::Recipient.find(1234).unsubscribed?.should == true
    end

    it "returns false if the recipient is not unsubscribed from anything" do
      EmailCenterApi::Recipient.find(2345).unsubscribed?.should == false
    end
  end

  describe ".lists" do
    it "returns all the lists where subscribed == 1" do
      EmailCenterApi::Recipient.find(1234).lists.first.id.should == 26
    end
  end

  describe ".find" do
    it "finds the recipient with the given id" do
      EmailCenterApi::Recipient.find(1234).id.should == 1234
    end

    it "creates the objects with the correct params" do
      EmailCenterApi::Recipient.find(1234).email_address.should == "test@example.co.uk"
    end
  end

  describe ".find_by_email" do
    it "finds the correct recipient" do
      EmailCenterApi::Recipient.find_by_email("test@example.co.uk").id.should == 1234
    end
  end
end
