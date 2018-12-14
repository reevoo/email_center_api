module FakeWebHelpers
  class Template
    def self.setup
      all_templates = [
        {
          text: "email_template",
          children: [
            { text: "A template", nodeId: "10", nodeClass: "email_template" },
            { text: "Another template", nodeId: "11", nodeClass: "email_template" },
            { text: "More templates", nodeId: "12", nodeClass: "email_template" },
          ]
        }
      ].to_json
      
      FakeWeb.register_uri(
        :get,
        'https://test:123@maxemail.emailcenteruk.com/api/json/tree?method=fetchRoot&tree=email_template&children[]=root',
        body: all_templates,
        content_type: 'application/json'
      )

      FakeWeb.register_uri(
        :post,
        'https://test:123@maxemail.emailcenteruk.com/api/json/email_send',
        body: all_templates,
        content_type: 'application/json'
      )
    end
  end
end

FakeWebHelpers::Template.setup
