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
      mapped_attributes = {}
      
      @@fields.each do |human, api|
        mapped_attributes[api] = self.attributes[human]
      end
      
      mapped_attributes
    end
    
    class << self
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