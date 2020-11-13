[0.1.0]: https://github.com/Mifrill/thread_safe_uniqueness_record/releases/tag/v0.1.0

## [0.1.0] ##

- module ThreadSafeUniquenessRecord base implementation

- ThreadSafeUniquenessRecord.with_retry - passed block as argument will fires with retries

- ThreadSafeUniquenessRecord::MAX_TRIES - limiter for retries (3 by default)

- ThreadSafeUniquenessRecord::ERRORS - UniquenessValidationError, ActiveRecord::RecordNotUnique

- ThreadSafeUniquenessRecord::FindOrCreateBy.call - model_klass: Rails model singleton class, attributes: for search
