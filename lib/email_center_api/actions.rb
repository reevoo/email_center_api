module EmailCenterApi
  class Actions

    def trigger(email_id, email_address, options)
      get(
        method: 'trigger',
        emailID: email_id,
        emailAddress: email_address,
        profileData: options
      ).validate_and_return_response
    end

    def get(query)
      ResponseValidator.new(HttpClient.get('/email_send', :query => query))
    end
  end
end
