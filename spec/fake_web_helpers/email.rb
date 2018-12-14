module FakeWebHelpers
  class Email
    class << self

      def setup
        setup_email_to_trigger
        setup_email_trigger
      end

      def setup_email_to_trigger
        url = "https://test:123@maxemail.emailcenteruk.com/api/json/tree?method=fetchTree&tree=email&nodeClass=folder&nodeId=123"

        FakeWeb.register_uri(:get, url,
          :body => [email_to_trigger].to_json,
          :content_type => 'application/json')
      end

      def setup_email_trigger
        url = "https://test:123@maxemail.emailcenteruk.com/api/json/email_send?method=trigger&emailID=10&emailAddress=test%40reevoo.com&profileData[Reviews][retailer_product_name]=Test%20product&profileData[Reviews][retailer_name]=test%20retailer&profileData[Reviews][retailer_from]=reply%40reevoo.com"

        FakeWeb.register_uri(:get, url,
          :body => {success: true, message: "Email queued successfully"}.to_json,
          :content_type => 'application/json')
      end

      private

      def email_to_trigger
        {text: "Test Email", nodeId: "10", nodeClass: "email"}
      end
    end
  end
end

FakeWebHelpers::Email.setup

