# EmailCenterApi

A RubyGem That wraps EmailCenter's maxemail JSON Api

see http://maxemail.emailcenteruk.com/manual/doku.php?id=maxemail:v6:webservices

## Installation

Add this line to your application's Gemfile:

    gem 'email_center_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_center_api

## Usage

Experimental and Feature Incomplete. Will allow some manipulation of
lists and recipients.

Try it out with something like this:

    require 'rubygems'
    require 'email_center_api'
    require 'pry'


    EmailCenterApi.configure do |config|
      config.username = 'yourusername'
      config.password = 'yourpassword'
    end

    binding.pry    

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write Some Tests
4. Write Some Code
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
