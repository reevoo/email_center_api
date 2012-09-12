module EmailCenterApi
  class List < EmailCenterApi::Base
    attr_accessor :name, :created_ts, :list_total, :folder_id, :type, :id, :status, :update_ts

    def initialize(name, created_ts, list_total, folder_id, type, id, status, update_ts)
      self.name = name
      self.created_ts = created_ts
      self.list_total = list_total.to_i
      self.folder_id = folder_id.to_i
      self.type = type
      self.id = id.to_i
      self.status = status
      self.update_ts = update_ts
    end

    def insert_recipient(options)
      self.class.insert_recipient(id, options)
    end

    def delete_recipient(recipient)
      self.class.delete_recipient(id,recipient.to_i)
    end

    def recipients
      response = self.class.get_with_retry("/list", :query => {:method => "fetchRecipients", "listId" => id, :limit => 100, :start => 0, :sort => "email_address", :dir => "ASC", :filter => ["email_address"]})
      recipients = []
      if response.success?
        response['records'].each do |record|
          recipients << EmailCenterApi::Recipient.new(record['recipient_id'],record['email_address'],record['update_ts'])
        end
      else
        raise_errors(response)
      end
      recipients
    end

    def self.find(list_id)
      response = get_with_retry("/list?method=find&listId=#{list_id}")
      if response.success?
        self.new(response['name'], response['created_ts'], response['list_total'], response['folder_id'],
             response['type'], response['list_id'], response['status'], response['update_ts'])
      else
        raise_errors(response)
      end
    end

    def self.all
      response = get_with_retry("/list?method=fetchAll")
      if response.success?
        lists = []
        response.each do |list|
          lists << self.new(list['name'], list['created_ts'], list['list_total'], list['folder_id'],
                        list['type'], list['list_id'], list['status'], list['update_ts'])
        end
        lists
      else
        raise response.response
      end
    end

    def self.find_by_name(name)
      lists = all.collect {|list| list if list.name == name}.compact
      if lists.empty?
        raise "Api Error: No list named #{name} was found"
      else
        lists.first
      end
    end

    def self.insert_recipient(list_id, options)
      body = { :method => "insertRecipient", :listId => list_id, :data => options }
      response = post("/list", {:body => body })
      if response.success?
        Recipient.new(response['recipient_id'],response['email_address'],response['update_ts'])
      else
        raise_errors(response)
      end
    end

    def self.delete_recipient(list_id, recipient_id)
      body = { :method => "deleteRecipient", :listId => list_id, :recipientId => recipient_id }
      response = post("/list", { :body => body })
      if response.success?
        response
      else
        raise_errors(response)
      end
    end
  end
end
