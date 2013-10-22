module EmailCenterApi::Nodes
  class TemplateNode
    TREE_ROOT = 'email_template'

    attr_reader :name, :node_id

    def initialize(name, node_id)
      @name = name
      @node_id = node_id.to_i
    end

    def self.all
      response = EmailCenterApi::Helpers::Tree.new(TREE_ROOT).root
      response.first['children'].map do |template|
        self.new(
          template['text'],
          template['nodeId']
        )
      end
    end
  end
end
