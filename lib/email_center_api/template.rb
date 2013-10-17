module EmailCenterApi
  class Template < EmailCenterApi::Base
    attr_accessor :text, :node_id

    def initialize(text, node_id)
      self.text = text
      self.node_id = node_id.to_i
    end

    def self.all
      response = get_tree('email_template')
      if response.success?
        templates = []
        response.first['children'].each do |template|
          templates << self.new(template['text'],
                                template['nodeId'])
        end
        templates
      else
        raise_errors response
      end
    end
  end
end
