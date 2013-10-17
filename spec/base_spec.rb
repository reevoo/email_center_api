require 'spec_helper'

describe EmailCenterApi::Base do

  describe '.get_root' do
    it 'returns a response with a valid node' do
      EmailCenterApi::Base.get_root('email_template').class.should == HTTParty::Response
    end

    it 'raises an error with an invalid node' do
      expect {
        EmailCenterApi::Base.get_root('some_root')
      }.to raise_error 'Api Error: Invalid Node Class'
    end
  end

  describe '.get_tree' do
    it 'returns a response with a valid node' do
      EmailCenterApi::Base.get_tree('email', 'folder', 0).class.should == HTTParty::Response
    end

    it 'raises an error with an invalid node' do
      expect {
        EmailCenterApi::Base.get_tree('some_root', 'folder', 0)
      }.to raise_error 'Api Error: Invalid Node Class'
    end
  end
end
