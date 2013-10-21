require 'spec_helper'

describe EmailCenterApi::Helpers::HttpClient do
  describe '#get' do

    before do
      described_class.reset
      described_class::Connection.stub(:get)
    end

    it 'uses the configured API endpoint' do
      described_class::Connection.should_receive(:base_uri).with(
        EmailCenterApi.config[:base_uri]
      )
      described_class.get('/tree')
    end

    it 'logs the user in' do
      described_class::Connection.should_receive(:basic_auth).with(
        EmailCenterApi.config[:username],
        EmailCenterApi.config[:password]
      )
      described_class.get('/tree')
    end

    context 'when a Timeout error is raised' do
      before do
        described_class::Connection.stub(:get) do
          @attempt ||= 0
          @attempt += 1
          raise(Timeout::Error) if @attempt <= 1
          'Valid Result'
        end
      end

      it 'retries the request' do
        described_class.get('/tree').should == 'Valid Result'
      end
    end

  end
end
