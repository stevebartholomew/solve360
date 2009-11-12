module Solve360
  module Item
    
    def self.included(model)
      model.extend ClassMethods
      model.send(:include, HTTParty)
      model.instance_variable_set(:@field_mapping, {})
    end
    
    # Base Item fields
    attr_accessor :id, :name, :typeid, :created, :updated, :viewed, :ownership, :flagged
    
    # Base item collections
    attr_accessor :fields, :related_items, :related_items_to_add
    
    def initialize(attributes = {})
      attributes.symbolize_keys!
      
      self.fields = {}
      self.related_items = []
      self.related_items_to_add = []
      
      [:fields, :related_items].each do |collection|
        self.send("#{collection}=", attributes[collection]) if attributes[collection]
        attributes.delete collection
      end

      attributes.each do |key, value|
        self.send("#{key}=", value)
      end
    end
    
    # @see Base::map_human_attributes
    def map_human_fields
      self.class.map_human_fields(self.fields)
    end
    
    # Save the attributes for the current record to the CRM
    #
    # If the record is new it will be created on the CRM
    # 
    # @return [Hash] response values from API
    def save
      response = []
      
      if self.ownership.blank?
        self.ownership = Solve360::Config.config.default_ownership
      end
      
      if new_record?
        response = self.class.request(:post, "/#{self.class.resource_name}", to_request)
        self.id = response["response"]["item"]["id"]
      else
        response = self.class.request(:put, "/#{self.class.resource_name}/#{id}", to_request)
      end
      
      related_items.concat(related_items_to_add)
      
      response
    end
    
    def new_record?
      self.id == nil
    end
    
    def to_request
      xml = "<request>"
      
      xml << map_human_fields.collect {|key, value| "<#{key}>#{value}</#{key}>"}.join("")
      
      if related_items_to_add.size > 0
        xml << "<relateditems>"
        
        related_items_to_add.each do |related_item|
          xml << %Q{<add><relatedto><id>#{related_item["id"]}</id></relatedto></add>}
        end
        
        xml << "</relateditems>"
      end
      
      xml << "<ownership>#{ownership}</ownership>"
      xml << "</request>"
      
      xml
    end
    
    def add_related_item(item)
      related_items_to_add << item
    end
    
    module ClassMethods
    
      # Map human map_human_fields to API fields
      # 
      # @param [Hash] human mapped fields
      # @example
      #   map_attributes("First Name" => "Steve", "Description" => "Web Developer")
      #   => {:firstname => "Steve", :custom12345 => "Web Developer"}
      # 
      # @return [Hash] API mapped attributes
      #
      def map_human_fields(fields)
        mapped_fields = {}

        field_mapping.each do |human, api|
          mapped_fields[api] = fields[human] if !fields[human].blank?
        end

        mapped_fields
      end
      
      # As ::map_api_fields but API -> human
      #
      # @param [Hash] API mapped attributes
      # @example
      #   map_attributes(:firstname => "Steve", :custom12345 => "Web Developer")
      #   => {"First Name" => "Steve", "Description" => "Web Developer"}
      #
      # @return [Hash] human mapped attributes
      def map_api_fields(fields)
        fields.stringify_keys!
        
        mapped_fields = {}

        field_mapping.each do |human, api|
          mapped_fields[human] = fields[api] if !fields[api].blank?
        end
        
        mapped_fields
      end
      
      # Create a record in the API
      #
      # @param [Hash] field => value as configured in Item::fields
      def create(fields, options = {})
        new_record = self.new(fields)
        new_record.save
        new_record
      end
      
      # Find a record 
      # 
      # @param [Integer] id of the record on the CRM
      def find(id)
        response = request(:get, "/#{resource_name}/#{id}")
                       
        construct_record_from_response(response)
      end
      
      # Send an HTTP request
      # 
      # @param [Symbol, String] :get, :post, :put or :delete
      # @param [String] url of the resource 
      # @param [String, nil] optional string to send in request body
      def request(verb, uri, body = "")
        send(verb, HTTParty.normalize_base_uri(Solve360::Config.config.url) + uri,
            :headers => {"Content-Type" => "application/xml", "Accepts" => "application/json"},
            :body => body,
            :basic_auth => {:username => Solve360::Config.config.username, :password => Solve360::Config.config.token})
      end
      
      def construct_record_from_response(response)
        item = response["response"]["item"]
        item.symbolize_keys!
        
        item[:fields] = map_api_fields(item[:fields])
      
        record = new(item)
        
        if response["response"]["relateditems"]
          related_items = response["response"]["relateditems"]["relatedto"]
        
          if related_items.kind_of?(Array)
            record.related_items.concat(related_items)
          else
            record.related_items = [related_items]
          end
        end
        
        record
      end
      
      def resource_name
        self.name.to_s.demodulize.underscore.pluralize
      end

      def map_fields(&block)        
        @field_mapping.merge! yield
      end
      
      def field_mapping
        @field_mapping
      end
    end
  end
end