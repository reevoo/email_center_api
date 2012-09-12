module EmailCenterApi
  class List < EmailCenterApi::Base
    attr_accessor :name, :created_ts, :list_total, :folder_id, :type, :id, :status, :update_ts

    def initialize(name, created_ts, list_total, folder_id, type, id, status, update_ts)
      self.name = name
      self.created_ts = created_ts
      self.list_total = list_total
      self.folder_id = folder_id
      self.type = type
      self.id = id.to_i
      self.status = status
      self.update_ts = update_ts
    end

    def insert_recipient(options)
      self.class.insert_recipient(id, options)
    end

    def self.find(list_id)
      require 'pry'
      #binding.pry
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
      body = { :listId => list_id, :data => options }
      options = {:body => body, :query => {:method => "insertRecipient"} }
      response = post("/list", options)
      if response.success?
        Recipient.new(response['recipient_id'],response['email_address'],response['update_ts'])
      end
    end
  end
end
