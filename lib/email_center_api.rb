module EmailCenterApi
  class AllErrors < StandardError; end
  class ApiError < AllErrors; end
  class HttpError < AllErrors; end
  class HttpTimeoutError < AllErrors; end

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
end

require 'httparty'
require 'yaml'
require 'delegate'

require "email_center_api/nodes/template_node"
require "email_center_api/nodes/email_node"

require "email_center_api/http_client"
require "email_center_api/response_validator"
require "email_center_api/query"
require "email_center_api/trigger"

require "email_center_api/version"
