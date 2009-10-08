require 'rubygems'

require File.join(File.dirname(__FILE__), '..', 'lib', 'solve360')

Solve360::Base.configure YAML::load(File.read(File.join(File.dirname(__FILE__), 'api_settings.yml')))

def file_fixture(filename)
  open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename.to_s}")).read
end
 
def stub_http_response_with(filename)
  format = filename.split('.').last.intern
  data = file_fixture(filename)
 
  response = Net::HTTPOK.new("1.1", 200, "Content for you")
  response.stub!(:body).and_return(data)
 
  http_request = HTTParty::Request.new(Net::HTTP::Get, 'http://localhost', :format => format)
  http_request.stub!(:perform_actual_request).and_return(response)
 
  HTTParty::Request.should_receive(:new).and_return(http_request)
end