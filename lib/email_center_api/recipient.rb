module EmailCenterApi
  class Recipient < EmailCenterApi::Base
    attr_accessor :id, :email_address, :domain_name, :updated_at

    def initialize(id,email_address, updated_at)
     self.id = id.to_i
     self.email_address = email_address
     self.updated_at = updated_at
    end

    def lists
      lists = self.class.get_with_retry("/recipient?method=fetchLists&recipientId=#{id}")
      if lists.success?
        lists.collect{ |list| list if list['subscribed'] == "1" }.compact.collect do |list|
          List.find(list['list_id'])
        end
      else
        raise lists.response
      end
    end

    def unsubscribed?
      !unsubscribed_from.empty?
    end

    def unsubscribed_from
      lists = self.class.get_with_retry("/recipient?method=fetchLists&recipientId=#{id}")
      if lists.success?
        lists.collect{ |list| list if list['subscribed'] == "0" }.compact.collect do |list|
          List.find(list['list_id'])
        end
      else
        raise lists.response
      end
    end

    def self.find(id)
      recipient = get_with_retry("/recipient?method=find&recipientId=#{id}")
      self.new(recipient['recipient_id'],recipient['email_address'],recipient['update_ts'])
    end

    def self.find_by_email(email_address)
      id = get_with_retry("/recipient?method=findByEmailAddress&emailAddress=#{email_address}")
      if id.success?
        recipient = get_with_retry("/recipient?method=find&recipientId=#{id.body}")
        if recipient.success?
          self.new(recipient['recipient_id'],recipient['email_address'],recipient['update_ts'])
        else
          raise 
        end
      else
        raise
      end
    end


  end
end
