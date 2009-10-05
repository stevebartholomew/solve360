require "httparty"
require "configatron"

["config", "model", "contact"].each do |lib|
  require File.join(File.dirname(__FILE__), "solve360", lib)
end