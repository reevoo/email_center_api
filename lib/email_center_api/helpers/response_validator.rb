module EmailCenterApi::Helpers
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
