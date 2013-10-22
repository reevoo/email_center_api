module FakeWebHelpers
  class Email
    class << self

      def setup
        #all_emails = [
        #  {text: "An email", nodeId: "10", nodeClass: "email"},
        #  {text: "Another email", nodeId: "11", nodeClass: "email"},
        #  {text: "More email", nodeId: "12", nodeClass: "email"}
        #].to_json
        #
        #FakeWeb.register_uri(:get, 'https://test:test@maxemail.emailcenteruk.com/api/json/tree?method=fetchRoot&tree=email&children[]=root',
        #  :body => all_emails,
        #  :content_type => 'application/json')
        setup_trigger_feature

      end

      def setup_trigger_feature
        url = "https://test:test@maxemail.emailcenteruk.com/api/json/tree?method=fetchTree&tree=email&nodeClass=folder&nodeId=123"

        FakeWeb.register_uri(:get, url,
          :body => [email_to_trigger].to_json,
          :content_type => 'application/json')
      end


      def email_to_trigger
        {text: "Test Email", nodeId: "10", nodeClass: "email"}
      end
    end
  end
end

FakeWebHelpers::Email.setup

