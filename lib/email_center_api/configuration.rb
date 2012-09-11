module EmailCenterApi
  module Configuration
    VALID_CONNECTION_KEYS = [:endpoint].freeze
    VALID_OPTIONS_KEYS    = [:username, :password].freeze
    VALID_CONFIG_KEYS     = VALID_CONNECTION_KEYS + VALID_OPTIONS_KEYS

    DEFAULT_USERNAME    = 'test'
    DEFAULT_PASSWORD    = 'test'
    DEFAULT_ENDPOINT     = 'https://maxemail.emailcenteruk.com/api/json/'
    # Build accessor methods for every config options so we can do this, for example:
    #   EmailCenterApi.endpoint = 'https://maxemail.emailcenteruk.com/api/json/'
    attr_accessor *VALID_CONFIG_KEYS

    # Make sure we have the default values set when we get 'extended'
    def self.extended(base)
      base.reset
    end

    #Configure the gem with a configure block
    def configure
      yield self
    end

    def reset
      self.username = DEFAULT_USERNAME
      self.password = DEFAULT_PASSWORD
      self.endpoint = DEFAULT_ENDPOINT
    end

  end # Configuration
end

