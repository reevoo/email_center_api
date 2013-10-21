require 'spec_helper'

describe EmailCenterApi::Email do
  describe '.all' do
    it 'returns an array' do
      EmailCenterApi::Email.all.class.should == Array
    end

    #it 'returns 3 items' do
    #  EmailCenterApi::Template.all.length.should == 3
    #end
    #
    #it 'returns Emails' do
    #  EmailCenterApi::Template.all.first.class.should == EmailCenterApi::Email
    #end
    #
    #it 'returns emails with the correct text and node_id' do
    #  email = EmailCenterApi::Email.all.first
    #  email.text.should == 'A template'
    #  email.node_id.should == 10
    #end
  end
end
