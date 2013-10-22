module EmailCenterApi::Trees
  class Node
    TREE_ROOT = 'email'

    attr_reader :name, :node_id, :node_class

    def initialize(name, node_id, node_class)
      @name = name
      @node_id = node_id.to_i
      @node_class = node_class
    end

    def ==(other)
      name == other.name &&
      node_id == other.node_id &&
      node_class == other.node_class
    end

    class << self
      def folder()

      end

      def emails(selectors)
        raise ArgumentError unless selectors[:folder]
        response = EmailCenterApi::Helpers::Tree.new(TREE_ROOT).tree('folder', selectors[:folder])
        response
          .select{|node| node['nodeClass'] =~ /^email/}
          .map { |node| build(node) }
      rescue EmailCenterApi::AllErrors
        []
      end

      #def all(node_id=0, node_class='folder')
      #  emails = []
      #  response = get_branch(node_class, node_id)
      #  response.each do |node|
      #    #p "Text: #{ node['text'] }, Class: #{ node['nodeClass'] }, ID: #{ node['nodeId'] }, hasChildren: #{ node['haschildren'] }"
      #    if node['nodeClass'].start_with?('email')
      #      print '.'
      #      emails << self.new(node['text'], node['nodeId'], node['nodeClass'])
      #    end
      #    if node['haschildren']
      #      print 'x'
      #      emails << all(node['nodeId'], node['nodeClass'])
      #    end
      #  end
      #  emails
      #end

      private

      def build(node)
        new(node['text'], node['nodeId'], node['nodeClass'])
      end

      #def get_branch(node_class, node_id)
      #  if node_id == 0
      #    EmailCenterApi::Helpers::Tree.new(TREE_ROOT).root
      #  else
      #    EmailCenterApi::Helpers::Tree.new(TREE_ROOT).tree(node_class, node_id)
      #  end
      #end
    end
  end
end
