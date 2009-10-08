require File.join(File.dirname(__FILE__), "..", "spec_helper")

class Person
  include Solve360::Model
  
  fields do
    { "Job Title" => "job_title" }
  end
end

describe "A Solve360 model" do
  it "should determine model name" do
    Person.resource_name.should == "people"
  end
  
  context "more than one model" do
    it "should not pollute fields" do
      class Car
        include Solve360::Model
        fields do
          { "Doors" => "doors" }
        end
      end
      
      Car.fields.keys.include?("Job Title").should be_false
      Person.fields.keys.include?("Doors").should be_false
    end
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
  
  it "should map human fields to API fields" do
    attributes = {"Description" => "A description"}
    
    Person.map_human_attributes(attributes)["custom_description"].should == "A description"
  end
  
  it "should map API fields to human fields" do
    attributes = {:custom_description => "A description"}
    
    Person.map_api_attributes(attributes)["Description"].should == "A description"
  end
end

describe "Creating a record" do
  context "directly from create" do
    before do
      stub_http_response_with("contacts/create-success.json")
      @contact = Solve360::Contact.create("First Name" => "Catherine")
    end
  
    it "should be valid" do
      @contact.attributes["First Name"].should == "Catherine"
      @contact.id.should == 12345
    end
  end
  
  context "creating a new object then saving" do
    before do
      stub_http_response_with("contacts/create-success.json")
      @contact = Solve360::Contact.new("First Name" => "Catherine")
      @contact.save
    end
    
    it "should be valid" do
      @contact.id.should == 12345
    end
  end
end

describe "Finding a record" do
  context "Successfully" do
    before do
      stub_http_response_with("contacts/find-success.json")
      @contact = Solve360::Contact.find(12345)
    end
  
    it "should find existing user" do
      @contact.attributes["First Name"].should == "Henry"
      @contact.id.should == 12345
    end
  end
end

describe "Updating a record" do
  before do
    @contact = Solve360::Contact.new("First Name" => "Steve")
    @contact.id = 12345
    
    stub_http_response_with("contacts/update-success.json")
    
    @contact.attributes["First Name"] = "Steve"
    @response = @contact.save
  end
  
  it "should be valid" do
    @response["response"]["status"].should == "success"
  end
end