# Solve360

Library for interacting with Norada's Solve360 CRM

http://norada.com/

## Usage

### Installing
  
The gem is hosted on [Gem Cutter](http://gemcutter.org):

    gem sources -a http://gemcutter.org
    gem install solve360

### Configuration

You can configure the API settings in a number of ways, but you must specify:

* url
* username
* token

The configuration uses [Configify](http://github.com/curve21/configify) so you can use a block or hash to define values:

    Solve360::Config.configure do |config|
      config.url = "https://secure.solve360.com"
      config.username = "user@user.com"
      config.token = "token"
    end

Because configure accepts a hash, you can configure with YAML:

    Solve360::Config.configure YAML.load(File.read("/path/to/file"))

And if you're using environments like Rails:

    Solve360::Config.configure YAML.load(File.read("/path/to/file"))[RAILS_ENV]

### Creating Records

Base attributes are set up for you.  Creating is simple:

    Solve360::Contact.create(:fields => "First Name" => "Stephen", "Last Name" => "Bartholomew")
    
Custom attributes can be added:

    Solve360::Contact.map_fields do
      {"Description" => "custom20394", "Location" => "custom392434"}
    end

and then used:

    contact = Solve360::Contact.create(:fields => "First Name" => "Steve", "Description" => "Web Developer", "Location" => "England")
    contact.id
    => The ID of the record created on the CRM
    
### Finding

You can find by the ID of a record on the CRM:

    contact = Solve360::Contact.find(12345)

### Saving

Once you have set the attributes on a model you can simply save:

    contact.fields["First Name"] = "Steve"
    contact.save

If the record does not have an ID it'll be created, otherwise the details will be saved.

### Related Items

Related items can be access via:
  
    contact.related_items
    => {"name" => "Curve21", "id" => "12345"}

And added:

    contact.add_related_item({"name" => "ACME Ltd", "id" => "91284"})
    contact.save
    
### Ownership

You can specify the ownership of a record directly:

    contact.ownership = 123456
    
Or you can add a default value to the configuration:

    config.default_ownership = 123456

If no ownership is specified, the default will be used. 

### API IDs

All Solve360 API IDs can be found in the 'My Account' > 'API Reference' section of the desktop.
    
## Support/Bugs

[Lighthouse](http://c21.lighthouseapp.com/projects/38966-solve360/overview)