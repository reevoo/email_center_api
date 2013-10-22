module EmailCenterApi::Nodes
  class EmailNode
    TREE_ROOT = 'email'

    class << self
      def all(selectors={})
        where(
          selectors[:folder] || 0,
          ->(node) { true }
        )
      end

      def folders(selectors={})
        where(
          selectors[:folder] || 0,
          ->(node) { node['nodeClass'] == 'folder' }
        )
      end

      def emails(selectors)
        raise ArgumentError unless selectors[:folder]

        where(
          selectors[:folder],
          ->(node) { node['nodeClass'] =~ /^email/ }
        )
      end

      private

      def where(folder_id, selector)
        EmailCenterApi::Query.new(TREE_ROOT)
        .tree('folder', folder_id)
        .select{ |node| selector.call(node) }
        .map { |node| build(node) }
      rescue EmailCenterApi::AllErrors
        []
      end

      def build(node)
        new(node['text'], node['nodeId'], node['nodeClass'])
      end
    end

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

    def folders
      super unless is_folder?
      self.class.folders(parent: node_id)
    end

    def emails
      super unless is_folder?
      self.class.emails(folder: node_id)
    end

    def trigger(email_address, options={})
      super if is_folder?
      EmailCenterApi::Actions.new.trigger(node_id, email_address, options)
    end

    def is_folder?
      node_class == 'folder'
    end
  end
end
