require "httparty"
require "configify"
require "active_support/inflector"
require "active_support/core_ext/hash"


["item", "config", "contact", "company"].each do |lib|
  require File.join(File.dirname(__FILE__), "solve360", lib)
end

module Solve360
  class SaveFailure < Exception
  end
end