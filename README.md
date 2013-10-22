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

### General configuration

    require 'email_center_api'

This will load a configuration yaml file from:

    'config/email_center_api.yml'

You can set a custom configuration file with:

    EmailCenterApi.config_path = 'path/to/config'

The config file should contain the keys:

    base_uri
    username
    password

### Email Node Class

The 'email' tree can be queried in the following ways:

    # All children elements of a node:
    EmailCenterApi::Nodes::EmailNode.all(selector)

    # Folders from a node:
    EmailCenterApi::Nodes::EmailNode.folders(selector)

    # Emails from a node:
    EmailCenterApi::Nodes::EmailNode.emails(selector)

where the selector contains an optional parameter to select the parent folder in the form:

    {  folder: <folder node id> }

This will return and array of EmailCenterApi::Nodes::EmailNode object.

### Email Node Instance

Each email node is a folder it can be queried in the following ways:

    node = EmailCenterApi::Nodes::EmailNode.all(selector).first

    # All children elements of a node:
    node.all

    # Folders from a node:
    node.folders

    # Emails from a node:
    node.emails

Alternatively an email node can be triggered to send an email:

    node = EmailCenterApi::Nodes::EmailNode.all(selector).first

    # All children elements of a node:
    node.trigger(<email_address>, <options>)

Where options is a hash containing the relevant profile data for the email.
See [Maxemail Documentation](http://maxemail.emailcenteruk.com/manual/doku.php?id=maxemail:v6:webservices:email_send#trigger) for more details.

### Email Template Node Instance

Can be used to query all templates within the tree:

    EmailCenterApi::Nodes::TemplateNode.all

This returns a array of template instances which exposes ```name``` and ```nodeId``` attributes.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write Some Tests
4. Write Some Code
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
