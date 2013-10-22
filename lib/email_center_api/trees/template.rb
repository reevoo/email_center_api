module EmailCenterApi::Trees
  class Template
    TREE_ROOT = 'email_template'

    attr_reader :name, :node_id

    def initialize(name, node_id)
      @name = name
      @node_id = node_id.to_i
    end

    def self.all
      response = EmailCenterApi::Helpers::Tree.new(TREE_ROOT).root
      templates = []
      response.first['children'].each do |template|
        templates << self.new(template['text'],
                              template['nodeId'])
      end
      templates
    end
  end
end
