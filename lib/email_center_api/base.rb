module EmailCenterApi
  class Base

    def to_i
      id
    end

    class << self
      def get_root(tree_root)
        Helpers::Tree.new(tree_root).root
      end

      def get_tree(tree_root, node_class, node_id)
        Helpers::Tree.new(tree_root).tree(node_class, node_id)
      end

      def get_node(node_class, node_id)
        Helpers::Tree.new.node(node_class, node_id)
      end
    end
  end
end
