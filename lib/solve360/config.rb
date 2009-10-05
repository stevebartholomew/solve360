module Solve360
  class API
    include Configatron::Config
    
    configure YAML::load(File.read(SOLVE360_CONFIG_PATH))
  end
end