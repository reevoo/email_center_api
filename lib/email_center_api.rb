module EmailCenterApi
  class AllErrors < StandardError; end
  class ApiError < AllErrors; end
  class HttpError < AllErrors; end

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

require "email_center_api/trees/template"
require "email_center_api/trees/node"

require "email_center_api/helpers/trigger"
require "email_center_api/helpers/http_client"
require "email_center_api/helpers/tree"

require "email_center_api/version"
