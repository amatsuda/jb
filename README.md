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


## The Generator
Jb extends the default Rails scaffold generator and adds some .jb templates.
If you don't need them, please configure like so.

```ruby
Rails.application.config.generators.jb false
```


## Bencharks
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
