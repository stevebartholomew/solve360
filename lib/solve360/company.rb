module Solve360
  class Company
    include Solve360::Item
    
    map_fields do
      {"Billing Address" => "billingaddress", 
      "Company Address" => "mainaddress", 
      "Company Fax" => "fax", 
      "Company Name" => "name", 
      "Company Phone" => "phone", 
      "Related To" => "relatedto", 
      "Shipping Address" => "shippingaddress", 
      "Website" => "website",
      "Background" => "background"}
    end
  end
end