# ActivePivot

An easy way to store your Pivotal Tracker projects, stories, and epics

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_pivot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_pivot

Next, generate the migrations by running:

    $ rails g active_pivot:migrations

Open up the "create_pivotal_stories" and change the line:

    t.text[] :tags

to:

    t.text :tags, array: true, default: []

Now, you can review the migrations and then run

    $ rake db:migrate

and the requisite tables will be created.

## Usage

Add your Pivotal Tracker API token to your secrets.yml:

`tracker_api_token: <%= ENV["PIVOTAL_TRACKER_API_TOKEN"] %>`

Now you can import your projects and stories using the following:

`rake active_pivot:import:pivotal_initial` for all activity up to 3 years ago

`rake active_pivot:import:pivotal_date[]` for all activity since a particular date
example: `rake active_pivot:import:date['August 12, 2015']`

`rake active_pivot:import:pivotal_update[]` for all activity since X minutes ago
example: `rake active_pivot:import:update[15]`

This gem will create the following models:
- [ActivePivot::Activity](lib/active_pivot/activity.rb)
- [ActivePivot::Epic](lib/active_pivot/epic.rb)
- [ActivePivot::EpicStory](lib/active_pivot/epic_story.rb)
- [ActivePivot::Project](lib/active_pivot/project.rb)
- [ActivePivot::Story](lib/active_pivot/story.rb)

You can subclass these models in your project to customize behavior.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## About Foraker Labs

<img src="http://assets.foraker.com/foraker_logo.png" width="400" height="62">

This project is maintained by Foraker Labs. The names and logos of Foraker Labs are fully owned and copyright Foraker Design, LLC.

Foraker Labs is a Boulder-based Ruby on Rails and iOS development shop. Please reach out if we can [help build your product](http://www.foraker.com).
