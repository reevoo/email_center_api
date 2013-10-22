require 'spec_helper'

describe EmailCenterApi::Nodes::EmailNode do
  describe '.emails' do
    context 'when a folder is specified' do

      it 'returns all emails in the specified folder' do
        json_object = [{ 'text' => 'Reevoo-test', 'nodeId' => '145', 'nodeClass' => 'email_template'}]

        expect_any_instance_of(
          EmailCenterApi::Query
        ).to receive(:tree).with('folder', 584).and_return(json_object)

        expect(described_class.emails(folder: 584)).to eq([
          described_class.new('Reevoo-test', 145, 'email_template')
        ])
      end

      it 'does not return sub-folders in the specified folder' do
        json_object = [{ 'text' => 'Reevoo-test', 'nodeId' => '145', 'nodeClass' => 'folder'}]

        expect_any_instance_of(
          EmailCenterApi::Query
        ).to receive(:tree).with('folder', 584).and_return(json_object)

        expect(described_class.emails(folder: 584)).to be_empty
      end

      it 'returns empty array when folder ID does not exist' do
        expect_any_instance_of(
          EmailCenterApi::Query
        ).to receive(:tree).and_raise(EmailCenterApi::ApiError)

        expect(described_class.emails(folder: 584)).to be_empty
      end
    end

    context 'when a folder is not specified' do
      it 'it retrievs elements from teh root node' do
        json_object = [{ 'text' => 'Reevoo-test', 'nodeId' => '145', 'nodeClass' => 'email_template'}]

        expect_any_instance_of(
          EmailCenterApi::Query
        ).to receive(:tree).with('folder', 0).and_return(json_object)

        expect(described_class.emails).to  eq([
          described_class.new('Reevoo-test', 145, 'email_template')
        ])

      end
    end
  end

  describe '.folders' do
    context 'when a parent node id is not passed in' do
      it 'queries the root node' do
        json_object = [{ 'text' => 'Reevoo-test', 'nodeId' => '145', 'nodeClass' => 'folder'}]

        expect_any_instance_of(
          EmailCenterApi::Query
        ).to receive(:tree).with('folder', 0).and_return(json_object)

        expect(described_class.folders).to eq([
          described_class.new('Reevoo-test', 145, 'folder')
        ])
      end
    end

    context 'when a parent node id is passed in' do
      it 'queries within the specified folder' do
        json_object = [{ 'text' => 'Reevoo-test', 'nodeId' => '145', 'nodeClass' => 'folder'}]

        expect_any_instance_of(
          EmailCenterApi::Query
        ).to receive(:tree).with('folder', 777).and_return(json_object)

        expect(described_class.folders(folder: 777)).to eq([
          described_class.new('Reevoo-test', 145, 'folder')
        ])
      end
    end
  end

  describe '.trigger' do
    context 'when an email type node' do
      let(:email_address) { 'test@reevoo.com' }
      let(:options) { {
        'Reviews' => {
          'retailer_product_name' => 'Test product',
          'retailer_name' => 'test retailer',
          'retailer_from' => 'reply@reevoo.com'
        }
      } }

      it 'will trigger sending of the email' do
        expect_any_instance_of(
          EmailCenterApi::Actions
        ).to receive(:trigger).with(100, email_address, options)

        email = described_class.new('Trigger Test', 100, 'email_triggered')
        email.trigger(email_address, options)
      end

      it 'will raise an arguement invalid error if node is not an email' do
        email = described_class.new('Trigger Test', 100, 'folder')
        expect {
          email.trigger(email_address, options)
        }.to raise_error(NoMethodError)

      end
    end
  end
end
