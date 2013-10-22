module EmailCenterApi::Helpers
  class Tree
    class TreeRootRequired < StandardError; end

    attr_reader :tree_root


    def initialize(tree_root=nil)
      @tree_root = tree_root
    end

    def root
      raise TreeRootRequired if tree_root.nil?
      get(
        method: 'fetchRoot',
        tree: tree_root,
        children: ['root']
      ).validate_and_return_response
    end

    def tree(node_class, node_id)
      raise TreeRootRequired if tree_root.nil?
      get(
        method: 'fetchTree',
        :tree => tree_root,
        :nodeClass => node_class,
        nodeId: node_id
      ).validate_and_return_response
    end

    def node(node_class, node_id)
      get(
        method: 'fetchNode',
        nodeClass: node_class,
        nodeId: node_id
      ).validate_and_return_response
    end

    private

    def get(query)
      ResponseValidator.new(HttpClient.get('/tree', :query => query))
    end

    class ResponseValidator
      attr_reader :response
      def initialize(response)
        @response = response
      end

      def validate_and_return_response
        raise_errors unless successful?
        response
      end

      private

      def raise_errors
        if response['msg']
          raise EmailCenterApi::ApiError, "Api Error: #{response['msg']}"
        else
          raise EmailCenterApi::HttpError, "status: #{response.code}"
        end
      end

      def successful?
        # Email center seems to only include response['success'] on failure.
        return false unless response.success?
        return true unless response.is_a?(Hash) && response['success'] == false
      end
    end
  end
end
