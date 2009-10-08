# Solve360

Library for interacting with Norada's Solve360 CRM

http://norada.com/

## Usage

### Configuration

You can configure the API settings in a number of ways, but you must specify:

* url
* username
* token

The configuration uses [Configify](http://github.com/curve21/configify) so you can use a block or hash to define values:

    Solve360::Base.configure do |config|
      config.url = "https://secure.solve360.com"
      config.username = "user@user.com"
      config.token = "token"
    end

Because configure accepts a hash, you can configure with YAML:

    Solve360::Base.configure YAML.load(File.read("/path/to/file"))

And if you're using environments like Rails:

    Solve360::Base.configure YAML.load(File.read("/path/to/file"))[RAILS_ENV]

### Creating Records

Base attributes are set up for you.  Creating is simple:

    Solve360::Contact.create("First Name" => "Stephen", "Last Name" => "Bartholomew")
    
Custom attributes can be added:

    Solve360::Contact.fields do
      {"Description" => "custom20394", "Location" => "custom392434"}
    end

and then used:

    contact = Solve360::Contact.create("First Name" => "Steve", "Description" => "Web Developer", "Location" => "England")
    contact.id
    => The ID of the record created on the CRM
    
### Finding

You can find by the ID of a record on the CRM:

    contact = Solve360::Contact.find(12345)

### Saving

Once you have set the attributes on a model you can simply save:

    contact.attributes["First Name"] = "Steve"
    contact.save

If the record does not have an ID it'll be created, otherwise the details will be saved.

## Support/Bugs

[Lighthouse](http://c21.lighthouseapp.com/projects/38966-solve360/overview)