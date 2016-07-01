# Jb

A simpler and faster Jbuilder alternative.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jb'
```

And bundle.


## Usage

Write a template that contains a Ruby code that returns a Ruby Hash / Array object.
Then the object will be `to_json`ed to a JSON String.


## Features

* No ugly builder syntax
* No `method_missing` calls
* `render_partial` with :collection option actually renders the collection (unlike Jbuilder)


## Contributing

Pull requests are welcome on GitHub at https://github.com/amatsuda/jb.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
