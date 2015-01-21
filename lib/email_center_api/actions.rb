module EmailCenterApi
  class Actions

    def trigger(email_id, email_address, options)
      post(
        method: 'trigger',
        emailID: email_id,
        emailAddress: email_address,
        profileData: options
      ).validate_and_return_response
    end

    def post(query)
      ResponseValidator.new(HttpClient.post('/email_send', body: query))
    end
  end
end
