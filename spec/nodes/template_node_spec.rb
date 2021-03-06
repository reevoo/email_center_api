require 'spec_helper'

describe EmailCenterApi::Nodes::TemplateNode do
  describe '.all' do
    it 'returns 3 items' do
      described_class.all.length.should == 3
    end

    it 'returns templates with the correct text and node_id' do
      template = described_class.all.first
      template.name.should == 'A template'
      template.node_id.should == 10
    end
  end
end
