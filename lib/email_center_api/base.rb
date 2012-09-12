module EmailCenterApi
  class Base
    include HTTParty
    default_timeout 10

    def self.get(*args, &block)
      base_uri EmailCenterApi.endpoint
      basic_auth EmailCenterApi.username, EmailCenterApi.password
      super(*args, &block)
    end

    def self.post(*args, &block)
      base_uri EmailCenterApi.endpoint
      basic_auth EmailCenterApi.username, EmailCenterApi.password
      super(*args, &block)
    end

    def self.raise_errors(response)
      if response['msg']
        raise "Api Error: #{response['msg']}"
      else
        raise "General Error!"
      end
    end

    def self.get_with_retry(url)
      base_uri EmailCenterApi.endpoint
      basic_auth EmailCenterApi.username, EmailCenterApi.password
      retries = 0
      begin
        get(url)
      rescue Timeout::Error
        raise if (self.retries += 1) > 3
        retry
      end
    end
  end
end
