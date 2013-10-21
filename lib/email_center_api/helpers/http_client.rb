module EmailCenterApi::Helpers
  class HttpClient

    class << self
      def get(*args)
        with_retries do
          connection.get(*args)
        end
      end

      def connection
        @connection ||= Connection.tap{ |con| con.configure(EmailCenterApi.config) }
      end

      def reset
        @connection = nil
      end

      private

      def with_retries(attempt=0, attempts=3)
        yield
      rescue Timeout::Error
        attempt += 1
        retry if attempt <= attempts
        raise
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
