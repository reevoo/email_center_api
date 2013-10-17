module EmailCenterApi
  class Base
    include HTTParty
    default_timeout 10

    def to_i
      id
    end

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
        raise "Email Center Api: General Error!"
      end
    end

    def self.get_with_retry(*args, &block)
      retries = 0
      begin
        get(*args, &block)
      rescue Timeout::Error
        raise if (self.retries += 1) > 3
        retry
      end
    end

    def self.get_tree(tree)
      get_with_retry('/tree', query: { method: 'fetchRoot', tree: tree, children: ['root'] })
    end
  end
end
