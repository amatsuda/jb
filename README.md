# Jb

A simpler and faster Jbuilder alternative.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jb'
```

And bundle.


## Usage

Put a template file named `*.jb` in your Rails app's `app/views/*` directory, and render it.


## Features

* No ugly builder syntax
* No `method_missing` calls
* `render_partial` with :collection option actually renders the collection (unlike Jbuilder)


## Syntax

A `.jb` template should contain Ruby code that returns any Ruby Object that responds_to `to_json` (generally Hash or Array).
Then the return value will be `to_json`ed to a JSON String.


## Examples

``` ruby
# app/views/messages/show.json.jb

json = {
  content: format_content(@message.content),
  created_at: @message.created_at,
  updated_at: @message.updated_at,
  author: {
    name: @message.creator.name.familiar,
    email_address: @message.creator.email_address_with_name,
    url: url_for(@message.creator, format: :json)
  }
}

if current_user.admin?
  json[:visitors] = calculate_visitors(@message)
end

json[:comments] = @message.comments.map do |comment|
  {
    content: comment.content,
    created_at: comment.created_at
  }
end

json[:attachments] = @message.attachments.map do |attachment|
  {
    filename: attachment.filename,
    url: url_for(attachment)
  }
end

json
```

This will build the following structure:

``` javascript
{
  "content": "10x JSON",
  "created_at": "2016-06-29T20:45:28-05:00",
  "updated_at": "2016-06-29T20:45:28-05:00",

  "author": {
    "name": "Yukihiro Matz",
    "email_address": "matz@example.com",
    "url": "http://example.com/users/1-matz.json"
  },

  "visitors": 1326,

  "comments": [
    { "content": "Hello, world!", "created_at": "2016-06-29T20:45:28-05:00" },
    { "content": "<script>alert('Hello, world!');</script>", "created_at": "2016-06-29T20:47:28-05:00" }
  ],

  "attachments": [
    { "filename": "sushi.png", "url": "http://example.com/downloads/sushi.png" },
    { "filename": "sake.jpg", "url": "http://example.com/downloads/sake.jpg" }
  ]
}
```

To define attribute and structure names dynamically, just use Ruby Hash.
Note that modern Ruby Hash syntax pretty much looks alike JSON syntax.
It's super-straight forward. Who needs a DSL to do this?

``` ruby
{author: {name: 'Matz'}}

# => {"author": {"name": "Matz"}}
```

Top level arrays can be handled directly.  Useful for index and other collection actions.
And you know, Ruby is such a powerful language for manipulating collections:

``` ruby
# @comments = @post.comments

@comments.reject {|c| c.marked_as_spam_by?(current_user) }.map do |comment|
  {
    body: comment.body,
    author: {
      first_name: comment.author.first_name,
      last_name: comment.author.last_name
    }
  }
end

# => [{"body": "🍣 is omakase...", "author": {"first_name": "Yukihiro", "last_name": "Matz"}}]
```

Jb has no special DSL method for extracting attributes from array directly, but you can do that with Ruby.

``` ruby
# @people = People.all

@people.map {|p| {id: p.id, name: p.name}}

# => [{"id": 1, "name": "Matz"}, {"id": 2, "name": "Nobu"}]
```

You can use Jb directly as an Action View template language.
When required in Rails, you can create views ala show.json.jb.
You'll notice in the following example that the `.jb` template
doesn't have to be one big Ruby Hash literal as a whole
but it can be any Ruby code that finally returns a Hash instance.

``` ruby
# Any helpers available to views are available in the template
json = {
  content: format_content(@message.content),
  created_at: @message.created_at,
  updated_at: @message.updated_at,

  author: {
    name: @message.creator.name.familiar,
    email_address: @message.creator.email_address_with_name,
    url: url_for(@message.creator, format: :json)
  }
}

if current_user.admin?
  json[:visitors] = calculate_visitors(@message)
end

json
```

You can use partials as well.  The following will render the file
`views/comments/_comments.json.jb`, and set a local variable
`comments` with all this message's comments, which you can use inside
the partial.

```ruby
render 'comments/comments', comments: @message.comments
```

It's also possible to render collections of partials:

```ruby
render partial: 'posts/post', collection: @posts, as: :post
```

> NOTE: Don't use `render @post.comments` because if the collection is empty,
`render` will return `nil` instead of an empty array.

You can pass any objects into partial templates with or without `:locals` option.

```ruby
render 'sub_template', locals: {user: user}

# or

render 'sub_template', user: user
```

You can of course include Ruby `nil` as a Hash value if you want. That would become `null` in the JSON.

You can use `Hash#compact`/`!` method to prevent including `null` values in the output:

```ruby
{foo: nil, bar: 'bar'}.compact

# => {"bar": "bar"}
```

If you want to cache a template fragment, just directly call `Rails.cache.fetch`:

```ruby
Rails.cache.fetch ['v1', @person], expires_in: 10.minutes do
  {name: @person.name, age: @person.age}
end
```


## The Generator
Jb extends the default Rails scaffold generator and adds some .jb templates.
If you don't need them, please configure like so.

```ruby
Rails.application.config.generators.jb false
```


## Why is Jb fast?

Jbuilder's `partial` + `:collection` [internally calls `array!` method](https://github.com/rails/jbuilder/blob/83a682aeebde96c6ef02ce742c0b97dc393f5e22/lib/jbuilder/jbuilder_template.rb#L85-L95)
inside which [`_render_partial` is called per each element of the given collection](https://github.com/rails/jbuilder/blob/83a682aeebde96c6ef02ce742c0b97dc393f5e22/lib/jbuilder/jbuilder_template.rb#L93),
and then it [falls back to the `view_context`'s `render` method](https://github.com/rails/jbuilder/blob/83a682aeebde96c6ef02ce742c0b97dc393f5e22/lib/jbuilder/jbuilder_template.rb#L100-L103).

So, for example if the collection has 100 elements, Jbuilder's `render partial:` performs `render` method 100 times, and so it calls `find_template` method (which is known as one of the heaviest parts of Action View) 100 times.

OTOH, Jb simply calls [ActionView::PartialRenderer's `render`](https://github.com/rails/rails/blob/49a881e0db1ef64fcbae2b7ddccfd5ccea26ae01/actionview/lib/action_view/renderer/partial_renderer.rb#L423-L443) which is cleverly implemented to `find_template` only once beforehand, then pass each element to that template.


## Benchmarks
Here're the results of a benchmark (which you can find [here](https://github.com/amatsuda/jb/blob/master/test/dummy_app/app/controllers/benchmarks_controller.rb) in this repo) rendering a collection to JSON.

### RAILS_ENV=development
```
% ./bin/benchmark.sh
* Rendering 10 partials via render_partial
Warming up --------------------------------------
                  jb    15.000  i/100ms
            jbuilder     8.000  i/100ms
Calculating -------------------------------------
                  jb    156.375  (± 7.0%) i/s -    780.000  in   5.016581s
            jbuilder     87.890  (± 6.8%) i/s -    440.000  in   5.037225s

Comparison:
                  jb:      156.4 i/s
            jbuilder:       87.9 i/s - 1.78x slower


* Rendering 100 partials via render_partial
Warming up --------------------------------------
                  jb    13.000  i/100ms
            jbuilder     1.000  i/100ms
Calculating -------------------------------------
                  jb    121.187  (±14.0%) i/s -    598.000  in   5.049667s
            jbuilder     11.478  (±26.1%) i/s -     54.000  in   5.061996s

Comparison:
                  jb:      121.2 i/s
            jbuilder:       11.5 i/s - 10.56x slower


* Rendering 1000 partials via render_partial
Warming up --------------------------------------
                  jb     4.000  i/100ms
            jbuilder     1.000  i/100ms
Calculating -------------------------------------
                  jb     51.472  (± 7.8%) i/s -    256.000  in   5.006584s
            jbuilder      1.510  (± 0.0%) i/s -      8.000  in   5.383548s

Comparison:
                  jb:       51.5 i/s
            jbuilder:        1.5 i/s - 34.08x slower
```


### RAILS_ENV=production
```
% RAILS_ENV=production ./bin/benchmark.sh
* Rendering 10 partials via render_partial
Warming up --------------------------------------
                  jb   123.000  i/100ms
            jbuilder    41.000  i/100ms
Calculating -------------------------------------
                  jb      1.406k (± 4.2%) i/s -      7.134k in   5.084030s
            jbuilder    418.360  (± 9.8%) i/s -      2.091k in   5.043381s

Comparison:
                  jb:     1405.8 i/s
            jbuilder:      418.4 i/s - 3.36x slower


* Rendering 100 partials via render_partial
Warming up --------------------------------------
                  jb    37.000  i/100ms
            jbuilder     5.000  i/100ms
Calculating -------------------------------------
                  jb    383.082  (± 8.4%) i/s -      1.924k in   5.061973s
            jbuilder     49.914  (± 8.0%) i/s -    250.000  in   5.040364s

Comparison:
                  jb:      383.1 i/s
            jbuilder:       49.9 i/s - 7.67x slower


* Rendering 1000 partials via render_partial
Warming up --------------------------------------
                  jb     4.000  i/100ms
            jbuilder     1.000  i/100ms
Calculating -------------------------------------
                  jb     43.017  (± 9.3%) i/s -    216.000  in   5.080482s
            jbuilder      4.604  (±21.7%) i/s -     23.000  in   5.082100s

Comparison:
                  jb:       43.0 i/s
            jbuilder:        4.6 i/s - 9.34x slower
```


### Summary

According to the benchmark results, you can expect 2-30x performance improvement in development env, and 3-10x performance improvement in production env.


## Contributing

Pull requests are welcome on GitHub at https://github.com/amatsuda/jb.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
