require "httparty"
require "email_center_api/version"
require "email_center_api/configuration"
require "email_center_api/base"


module EmailCenterApi
  extend Configuration
end

require "email_center_api/template"
require "email_center_api/email"
