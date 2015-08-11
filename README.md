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

Create a new rake task called `import.rake`

```
namespace :import do

  task pivotal_update: :environment do
    interval = 15.minutes.ago
    ActivePivot::Importer.run(interval)
  end

  task pivotal_initial: :environment do
    interval = 3.years.ago
    ActivePivot::Importer.run(interval)
  end
end
```

Initialize your database by running `rake import:pivotal_initial`

You can then easily update it with `rake import:pivotal_update`

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/foraker/active_pivot.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

