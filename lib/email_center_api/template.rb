module EmailCenterApi
  class Template
    TREE_ROOT = 'email_template'

    attr_accessor :text, :node_id

    def initialize(text, node_id)
      self.text = text
      self.node_id = node_id.to_i
    end

    def self.all
      response = Helpers::Tree.new(TREE_ROOT).root
      templates = []
      response.first['children'].each do |template|
        templates << self.new(template['text'],
                              template['nodeId'])
      end
      templates
    end
  end
end
