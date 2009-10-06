module Solve360
  class Model
    include HTTParty
  
    base_uri Solve360::API.config.url
    basic_auth Solve360::API.config.username, Solve360::API.config.token
    
    attr_accessor :attributes
    
    def initialize
      self.attributes = {}
    end
    
    def map_attributes
      self.class.map_attributes(self.attributes)
    end
    
    class << self
      def map_attributes(attributes)
        mapped_attributes = {}

        @@fields.each do |human, api|
          mapped_attributes[api] = attributes[human]
        end

        mapped_attributes
      end
      
      def create(attributes)
        post("/#{resource_name}",   
              :headers => {"Content-Type" => "application/xml", "Accepts" => "application/json"}, 
              :body => map_attributes(attributes).to_xml(:root => "request"))
      end
      
      def resource_name
        self.name.to_s.demodulize.underscore.pluralize
      end
      
      @@fields = {}
      
      def fields(&block)
        if block_given?
          @@fields.merge! yield
        else
          @@fields
        end
      end
    end
  end
end