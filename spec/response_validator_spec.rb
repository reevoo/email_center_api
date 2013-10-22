require 'spec_helper'

describe EmailCenterApi::ResponseValidator do

  describe "#validate_and_return_response" do
    subject { described_class.new(response) }

    class TestResponse
      def initialize(options)
        @options = options
      end

      def success?
        @options[:success?]
      end

      def [](key)
        (@options[:data] || {})[key]
      end

      def code
        '404'
      end

      def is_a?(obj)
        obj == Hash
      end
    end

    context 'when response is valid' do
      let(:response) { TestResponse.new({success?: true}) }

      it 'return response' do
        expect(subject.validate_and_return_response).to eq(response)
      end
    end

    context 'when success? is false' do
      context 'and no msg is set' do
        let(:response) { TestResponse.new(success?: false) }

        it 'return response' do
          expect {
            subject.validate_and_return_response
          }.to raise_error(EmailCenterApi::HttpError)
        end
      end

      context 'and msg is set' do
        let(:response) { TestResponse.new(success?: false, data: {'msg' => 'error'}) }

        it 'return response' do
          expect {
            subject.validate_and_return_response
          }.to raise_error(EmailCenterApi::ApiError)
        end
      end
    end

    context 'when success is true but response is a hash and success key is false' do
      let(:response) { TestResponse.new(success?: true, data: {'success' => false}) }

      it 'return response' do
        expect {
          subject.validate_and_return_response
        }.to raise_error(EmailCenterApi::HttpError)
      end
    end
  end
end
