[0.1.3]: https://github.com/mifrill/thread_safe_uniqueness_record/compare/v0.1.2...v0.1.3

- FIX: add files to gem-release / required_ruby_version => 2.6 / cleanup README.md

[0.1.2]: https://github.com/mifrill/thread_safe_uniqueness_record/compare/v0.1.1...v0.1.2

## [0.1.2] ##

- cleanup thread_safe_uniqueness_record.gemspec / README.md / CHANGELOG.md

[0.1.1]: https://github.com/mifrill/thread_safe_uniqueness_record/compare/v0.1.0...v0.1.1

## [0.1.1] ##

- ThreadSafeUniquenessRecord.with_retry required block as argument

- add spec for context: 'when Validation failed by not "taken" reason'

[0.1.0]: https://github.com/Mifrill/thread_safe_uniqueness_record/releases/tag/v0.1.0

## [0.1.0] ##

- module ThreadSafeUniquenessRecord base implementation

- ThreadSafeUniquenessRecord.with_retry - passed block as argument will fires with retries

- ThreadSafeUniquenessRecord::MAX_TRIES - limiter for retries (3 by default)

- ThreadSafeUniquenessRecord::ERRORS - UniquenessValidationError, ActiveRecord::RecordNotUnique

- ThreadSafeUniquenessRecord::FindOrCreateBy.call - model_klass: Rails model singleton class, attributes: for search
