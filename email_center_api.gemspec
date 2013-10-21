# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'email_center_api/version'
require 'base64'

Gem::Specification.new do |gem|
  gem.name          = "email_center_api"
  gem.version       = EmailCenterApi::VERSION
  gem.authors       = ["Ed Robinson"]
  gem.email         = Base64.decode64("ZWQucm9iaW5zb25AcmVldm9vLmNvbQ==\n")
  gem.description   = "A RubyGem That wraps EmailCenter's maxemail JSON Api"
  gem.summary       = "A RubyGem That wraps EmailCenter's maxemail JSON Api"
  gem.homepage      = "https://github.com/reevoo/email_center_api"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency("httparty", "~> 0.9.0")
  gem.add_dependency("json", "~> 1.7.5")
  gem.add_development_dependency("fakeweb", "~> 1.3.0")
  gem.add_development_dependency("rspec", "~> 2.11.0")
  gem.add_development_dependency("pry")
  gem.add_development_dependency("pry-debugger")
end
