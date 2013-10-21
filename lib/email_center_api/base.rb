module EmailCenterApi
  class Base

    def to_i
      id
    end

    class << self

      def raise_errors(response)
        if response['msg']
          raise "Api Error: #{response['msg']}"
        else
          raise "Email Center Api: General Error!"
        end
      end

      def get_root(tree)
        EmailCenterApi::Helpers::HttpClient
        response = EmailCenterApi::Helpers::HttpClient.get('/tree', :query =>
            {:method => 'fetchRoot',
             :tree => tree,
             :children => ['root']})

        if successful?(response)
          return response
        else
          raise_errors(response)
        end
      end

      def get_tree(tree, node_class, node_id)
        response = EmailCenterApi::Helpers::HttpClient.get('/tree', :query =>
            {:method => 'fetchTree',
             :tree => tree,
             :nodeClass => node_class,
             :nodeId => node_id})

        if successful?(response)
          return response
        else
          raise_errors(response)
        end
      end

      def get_node(node_class, node_id)
        response = EmailCenterApi::Helpers::HttpClient.get('/tree', :query =>
            {:method => 'fetchNode',
             :nodeClass => node_class,
             :nodeId => node_id})

        if successful?(response)
          return response
        else
          raise_errors(response)
        end
      end

      private

      def successful?(response)
        # Email center seems to only include response['success'] on failure.
        return false unless response.success?
        return true unless (response.is_a?(Hash) &&
            (response['success'] == false))
      end
    end
  end
end
