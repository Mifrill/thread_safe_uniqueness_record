[![CircleCI](https://circleci.com/gh/Mifrill/thread_safe_uniqueness_record.svg?style=svg)](https://app.circleci.com/pipelines/github/Mifrill/thread_safe_uniqueness_record)

# ThreadSafeUniquenessRecord

Usage is raised by thread race when the first thread tries to create
the record at the same time the second thread is trying to create exactly
the same record because both threads are seen no such record in DB
on find_by action by the passed attributes.

[Rails implementation of `create_or_find_by`](https://github.com/rails/rails/blob/24c1429a9e553196eb72312ec831afb6268222b1/activerecord/lib/active_record/relation.rb#L179-L222)

In thread race when both of threads proceed after the passed
uniqueness validation in model without raise of RecordInvalid error
and one of the thread has committed the change in DB then the second thread
fires the RecordNotUnique error with retry on the rescue.

The attempts limiter is required to prevent the infinite loop when tries
to create the record which can't be found by the passed attributes but
becomes a duplicate by any other attributes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thread_safe_uniqueness_record'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install thread_safe_uniqueness_record

## Usage

    model_klass: ActiveRecordModel
    attributes: Hash of model instance attributes

    ThreadSafeUniquenessRecord::FindOrCreateBy.call(model_klass: model_klass, attributes: attributes)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

https://rubygems.org/gems/thread_safe_uniqueness_record

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Mifrill/thread_safe_uniqueness_record. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Mifrill/thread_safe_uniqueness_record/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ThreadSafeUniquenessRecord project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Mifrill/thread_safe_uniqueness_record/blob/master/CODE_OF_CONDUCT.md).
