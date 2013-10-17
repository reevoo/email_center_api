require 'spec_helper'

describe EmailCenterApi::Email do
  describe '.all' do
    it 'returns an array' do
      EmailCenterApi::Email.all.class.should == Array
    end
  end
end
