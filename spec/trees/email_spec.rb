require 'spec_helper'

describe EmailCenterApi::Trees::Email do
  describe '.all' do
    it 'returns 3 items' do
      described_class.all.length.should == 3
    end

    it 'returns templates with the correct text and node_id' do
      template = described_class.all.first
      template.name.should == 'An email'
      template.node_id.should == 10
    end
  end

  describe '.emails' do
    context 'when a folder is specified' do

      it 'returns all emails in the specified folder' do
        json_object = [{ 'text' => 'Reevoo-test', 'nodeId' => '145', 'nodeClass' => 'email_template'}]

        expect_any_instance_of(
          EmailCenterApi::Helpers::Tree
        ).to receive(:tree).with('folder', 584).and_return(json_object)

        expect(described_class.emails(folder: 584)).to eq([
          described_class.new('Reevoo-test', 145, 'email_template')
        ])
      end

      it 'does not return sub-folders in the specified folder' do
        json_object = [{ 'text' => 'Reevoo-test', 'nodeId' => '145', 'nodeClass' => 'folder'}]

        expect_any_instance_of(
          EmailCenterApi::Helpers::Tree
        ).to receive(:tree).with('folder', 584).and_return(json_object)

        expect(described_class.emails(folder: 584)).to be_empty
      end

      it 'returns empty array when folder ID does not exist' do
        expect_any_instance_of(
          EmailCenterApi::Helpers::Tree
        ).to receive(:tree).and_raise(EmailCenterApi::ApiError)

        expect(described_class.emails(folder: 584)).to be_empty
      end
    end

    context 'when a folder is not specified' do
      it 'raises an argument not found error' do
        expect { described_class.emails(dashboard: 584) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.folder' do
    context 'when a parent node id is not passed in' do
      it 'queries the root node' do
        json_object = [{ 'text' => 'Reevoo-test', 'nodeId' => '145', 'nodeClass' => 'folder'}]

        expect_any_instance_of(
          EmailCenterApi::Helpers::Tree
        ).to receive(:root).and_return(json_object)

        expect(described_class.emails(folder: 584)).to eq([

        ])

      end
    end
  end
end
