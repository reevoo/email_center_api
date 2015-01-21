module EmailCenterApi
  class HttpClient

    class << self
      def get(*args)
        with_retries do
          connection.get(*args)
        end
      end

      def post(*args)
        with_retries do
          connection.post(*args)
        end
      end

      def connection
        @connection ||= Connection.tap{ |con| con.configure(EmailCenterApi.config) }
      end

      def reset
        @connection = nil
      end

      private

      def with_retries(attempts=3)
        error = nil
        attempts.times do
          begin
            return yield
          rescue Timeout::Error => e
            error = e
          end
        end
        raise EmailCenterApi::HttpTimeoutError.new(error.message)
      end
    end

    class Connection
      include HTTParty
      default_timeout 10

      class << self

        def configure(config)
          base_uri config['base_uri']
          basic_auth config['username'], config['password']
        end
      end
    end
  end
end
