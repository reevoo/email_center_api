module EmailCenterApi
  class Base
    include HTTParty
    default_timeout 10

    def to_i
      id
    end

    class << self

      def get(*args, &block)
        base_uri EmailCenterApi.endpoint
        basic_auth EmailCenterApi.username, EmailCenterApi.password
        super(*args, &block)
      end

      def post(*args, &block)
        base_uri EmailCenterApi.endpoint
        basic_auth EmailCenterApi.username, EmailCenterApi.password
        super(*args, &block)
      end

      def raise_errors(response)
        if response['msg']
          raise "Api Error: #{response['msg']}"
        else
          raise "Email Center Api: General Error!"
        end
      end

      def get_with_retry(*args, &block)
        retries = 0
        begin
          get(*args, &block)
        rescue Timeout::Error
          raise if (self.retries += 1) > 3
          retry
        end
      end

      def get_root(tree)
        response = get_with_retry('/tree', :query =>
            {:method => 'fetchRoot',
             :tree => tree,
             :children => ['root']})

        if successful?(response)
          return response
        else
          raise_errors(response)
        end
      end

      private

      def successful?(response)
        # Email center seems to only include response['success'] on failure.
        return false unless response.success?
        return true unless (response.is_a?(Hash) &&
            (response['success'] == false))
      end
    end
  end
end
