require 'spec_helper'

describe 'configuration' do
  after(:each) do
    EmailCenterApi.reset
  end

  EmailCenterApi::Configuration::VALID_CONFIG_KEYS.each do |key|
    describe ".#{key}" do
      it 'should return the default value' do
        EmailCenterApi.send(key).should == EmailCenterApi::Configuration.const_get("DEFAULT_#{key.to_s.upcase}")
      end
    end
  end

  describe '.configure' do
    EmailCenterApi::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the #{key}" do
        EmailCenterApi.configure do |config|
          config.send("#{key}=", key)
        end
        EmailCenterApi.send(key).should == key
      end
    end
  end


end
