# Solve360

Library for interacting with Norada's Solve360 CRM

http://norada.com/

## Usage

Base attributes are set up for you.  Creating is simple:

    Contact.create("First Name" => "Stephen", "Last Name" => "Bartholomew")
    
Custom attributes can be added:

    Contact.fields do
      {"Description" => "custom20394", "Location" => "custom392434"}
    end

and then used:

    Contact.create("First Name" => "Steve", "Description" => "Web Developer", "Location" => "England")

## Response

Currently, you'll receive the returned JSON parsed to a hash:
    
    response = Contact.create("First Name" => "Stephen", "Last Name" => "Bartholomew")
    response["response"]["status"]
    => true