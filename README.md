# Ruby Montage

A Ruby wrapper for the [Montage](https://www.foo.com) API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-montage'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-montage

## Usage

In order to use the API, you will first have to retrieve an authorization token

    client = Montage::Client.new do |c|
      c.username = "YOUR_USERNAME"
      c.password = "YOUR_PASSWORD"
      c.api_version # Optional, defaults to 1
      c.domain = "test" # Your Montage subdomain
    end

    response = client.auth
    token = response.token.value

This token does not expire, so it is recommended that you store this token somewhere in your database to avoid having to
make an API call to retrieve it on every request.

After retrieving a token, you can simply initialize the client with your token

    client = Montage::Client.new do |c|
      c.token = "YOUR_TOKEN"
      c.domain = "test" # Your Montage subdomain
    end

All API actions are available as methods on the client object. The following methods are available:

## Files

| Action                          | Method                                              |
| :------------------------------ | :-------------------------------------------------- |
| Get a list of files             | `#files`                                            |
| Get a single file               | `#file(file_id)`                                    |
| Upload a new file               | `#new_file(file)`                                   |
| Delete a file                   | `#destroy_file(file_id)`                            |

## Schemas

| Action                          | Method                                              |
| :------------------------------ | :-------------------------------------------------- |
| Get a list of schemas           | `#schemas`                                          |
| Fetch a single schema           | `#schemas(name)`                                    |

## Documents

| Action                          | Method                                              |
| :------------------------------ | :-------------------------------------------------- |
| Query documents in a schema     | `#documents(schema, query)`                         |
| Fetch a single document         | `#document(schema, document_uuid)`                  |
| Fetch the next set of documents | `#document_cursor(schema, cursor)`                  |
| Create a new document           | `#create_document(schema, document)`                |
| Update a document               | `#update_document(schema, document_uuid, document)` |
| Delete a document               | `#delete_document(schema, document_uuid)`           |

## Examples


## Contributing

1. Fork it ( https://github.com/[my-github-username]/ruby-montage/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
