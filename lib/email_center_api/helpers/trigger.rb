module EmailCenterApi::Helpers
  class Trigger

    def trigger(email_id, email_address, options)
      get(
        method: 'trigger',
        emailID: email_id,
        emailAddress: email_address,
        profileData: options
      )#.validate_and_return_response

      #array email_send.trigger( int emailId, string emailAddress, array profileData )
    end


    def get(query)
      if $show_curl
        puts HTTParty::Request.new(Net::HTTP::Get, '/email_send', query: query).uri.to_s
      end
      HttpClient.get('/email_send', :query => query)
    end
  end
end
