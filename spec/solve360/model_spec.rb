require File.join(File.dirname(__FILE__), "..", "spec_helper")

class Person < Solve360::Model
  fields do
    { "Job Title" => "job_title" }
  end
end

describe "A Solve360 model" do
  it "should determine model name" do
    Person.resource_name.should == "people"
  end
end

describe "Field mapping" do
  before do
    Person.fields do 
      {"Interests"	=> "custom_interests",
      "Department Website" => "custom_deptwebsite",
      "Description" => "custom_description"}
    end
    
    @person = Person.new
  end
  
  it "should set base fields" do
    Person.fields["Job Title"].should == "job_title"
  end
  
  it "should set custom fields" do
    Person.fields["Interests"].should == "custom_interests"
  end
  
  it "should allow setting of values on an instance via field maps" do
    @person.attributes["Interests"] = "Coding"
    @person.attributes["Interests"].should == "Coding"
  end
  
  it "should parse field mappings & values" do
    @person.attributes["Description"] = "A description"
    
    @person.map_attributes["custom_description"].should == "A description"
  end
end

describe "Creating a record" do
  before do
    stub_http_response_with("contacts/create-success.json")
    @response = Person.create("First Name" => "Steve", "Description" => "Web Developer")
  end
  
  it "should be valid" do
    @response["response"]["status"].should == "success"
  end
end