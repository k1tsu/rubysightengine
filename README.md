# Rubysightengine

An easy to use sightengine wrapper for ruby. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubysightengine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubysightengine

## Usage

### General 

A SightEngine class is provided which will give access to the method `check`. Once the data has been receieved from SightEngine, a new `Checked` object will be created. 
There are five different `Checked` methods used to get the data from the request, all are below, discluding the method `.raw` which will give the request's body. The minimum testing value is defaulted at `0.9`.

### Workflows 

`.set_workflow(...)` can be used to set the current workflow, or it can be set as an argument when creating a new SightEngine object. These are completely optional and are manipulated in the SightEngine interface.

```ruby 
require "rubysightengine"

s = SightEngine.new(api_user, api_secret, optional_workflow)

s.set_workflow(new_workflow) # Optional 

b = s.check (
    "https://images.unsplash.com/photo-1533227268428-f9ed0900fb3b?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aGFwcHklMjBtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80", 
    'nudity', 
    'offensive'
)

b.set_min(0.5) # Optional 

b.safe? # => {"nudity"=>true}

b.has? 'nudity', 'offensive' # => {"nudity"=>false, "offensive"=>false}

b.stat_hash 'offensive', 'nudity' # => [{"prob"=>0.117, "boxes"=>[{"x1"=>0.29997, "y1"=>0.49264, "x2"=>0.39483, "y2"=>0.6242, "label"=>"middlefinger", "prob"=>0.117}, {"x1"=>0.61118, "y1"=>0.43277, "x2"=>0.70978, "y2"=>0.56579, "label"=>"middlefinger", "prob"=>0.052}]}, {"raw"=>0.01, "partial"=>0.01}]

b.boxes # => [{"x1"=>0.29997, "y1"=>0.49264, "x2"=>0.39483, "y2"=>0.6242, "label"=>"middlefinger", "prob"=>0.117}]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rubysightengine.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
