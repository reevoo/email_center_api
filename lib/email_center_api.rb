require "httparty"
require "email_center_api/version"
require "email_center_api/configuration"
require "email_center_api/base"
require 'yaml'

module EmailCenterApi
  DEFAULT_PATH = 'config/email_center_api.yml'

  def config
    @config ||= YAML.load_file(config_path)
  end

  def config_path
    @config_path || DEFAULT_PATH
  end

  def config_path=(path)
    @config_path = path
    @config = nil
  end

  extend self
  extend Configuration
end

require "email_center_api/template"
require "email_center_api/email"

require "email_center_api/helpers/http_client"
