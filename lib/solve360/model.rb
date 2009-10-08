module Solve360
  module Model
    
    def self.included(model)
      model.extend ClassMethods
      model.send(:include, HTTParty)
      model.instance_variable_set(:@fields, {})
    end
    
    attr_accessor :attributes, :id
    
    def initialize(attributes = {})
      self.attributes = attributes
      self.id = nil
    end
    
    # @see Base::map_human_attributes
    def map_human_attributes
      self.class.map_human_attributes(self.attributes)
    end
    
    # Save the attributes for the current record to the CRM
    #
    # If the record is new it will be created on the CRM
    # 
    # @return [Hash] response values from API
    def save
      if new_record?
        new_record = self.class.create(attributes)
        self.id = new_record.id
      else
        self.class.request(:put, "/#{self.class.resource_name}/#{id}", map_human_attributes.to_xml(:root => "request"))
      end
    end
    
    def new_record?
      self.id == nil
    end

    module ClassMethods
    
      # Map human attributes to API attributes
      # 
      # @param [Hash] human mapped attributes
      # @example
      #   map_attributes("First Name" => "Steve", "Description" => "Web Developer")
      #   => {:firstname => "Steve", :custom12345 => "Web Developer"}
      # 
      # @return [Hash] API mapped attributes
      #
      def map_human_attributes(attributes)
        mapped_attributes = {}

        fields.each do |human, api|
          mapped_attributes[api] = attributes[human] if !attributes[human].blank?
        end

        mapped_attributes
      end
      
      # As ::map_human_attributes but API -> human
      #
      # @param [Hash] API mapped attributes
      # @example
      #   map_attributes(:firstname => "Steve", :custom12345 => "Web Developer")
      #   => {"First Name" => "Steve", "Description" => "Web Developer"}
      #
      # @return [Hash] human mapped attributes
      def map_api_attributes(attributes)
        attributes.stringify_keys!
        
        mapped_attributes = {}

        fields.each do |human, api|
          mapped_attributes[human] = attributes[api] if !attributes[api].blank?
        end
        
        mapped_attributes
      end
      
      # Create a record in the API
      #
      # @param [Hash] field => value as configured in Model::fields
      def create(attributes)
        response = request(:post, "/#{resource_name}", map_human_attributes(attributes).to_xml(:root => "request"))
              
        construct_record_from_response(response)
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
        attributes = map_api_attributes(response["response"]["item"]["fields"])
        
        record = new(attributes)

        record.id = response["response"]["item"]["id"].to_i
        record
      end
      
      def resource_name
        self.name.to_s.demodulize.underscore.pluralize
      end

      def fields(&block)        
        if block_given?
          @fields.merge! yield
        else
          @fields
        end
      end
    end
  end
end