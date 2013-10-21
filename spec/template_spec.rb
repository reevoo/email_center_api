require 'spec_helper'

describe EmailCenterApi::Template do
  describe '.all' do
    it 'returns 3 items' do
      EmailCenterApi::Template.all.length.should == 3
    end

    it 'returns templates with the correct text and node_id' do
      template = EmailCenterApi::Template.all.first
      template.text.should == 'A template'
      template.node_id.should == 10
    end
  end
end
