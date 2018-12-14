require 'spec_helper'

describe EmailCenterApi do
  describe 'config' do
    it 'loads yaml file' do
      expect(described_class.config['base_uri']).to eq('https://maxemail.emailcenteruk.com/api/json/')
      expect(described_class.config['username']).to eq('test')
      expect(described_class.config['password']).to eq(123)
    end
  end
end
