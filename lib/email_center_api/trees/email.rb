module EmailCenterApi::Trees
  class Email
    TREE_ROOT = 'email'

    attr_accessor :text, :node_id, :node_class

    def initialize(text, node_id, node_class)
      self.text = text
      self.node_id = node_id.to_i
      self.node_class = node_class
    end

    class << self

      def all(node_id=0, node_class='folder')
        emails = []

        response = get_branch(node_class, node_id)
        response.each do |node|
          #p "Text: #{ node['text'] }, Class: #{ node['nodeClass'] }, ID: #{ node['nodeId'] }, hasChildren: #{ node['haschildren'] }"
          if node['nodeClass'].start_with?('email')
            emails << self.new(node['text'], node['nodeId'], node['nodeClass'])
          end
          if node['haschildren']
            emails << all(node['nodeId'], node['nodeClass'])
          end
        end
        emails
      end

      private

      def get_branch(node_class, node_id)
        if node_id == 0
          EmailCenterApi::Helpers::Tree.new(TREE_ROOT).root
        else
          EmailCenterApi::Helpers::Tree.new(TREE_ROOT).tree(node_class, node_id)
        end
      end
    end
  end
end
