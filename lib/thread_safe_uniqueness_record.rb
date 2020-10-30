require 'thread_safe_uniqueness_record/version'
require 'thread_safe_uniqueness_record/find_or_create_by'
require 'active_record'
require 'concurrent'

module ThreadSafeUniquenessRecord
  class Error < StandardError; end

  class UniquenessValidationError
    def self.===(exception)
      exception.is_a?(ActiveRecord::RecordInvalid) &&
        /Validation failed:.+\btaken\b/.match?(exception.message)
    end
  end

  MAX_TRIES = 3
  ERRORS = [
    UniquenessValidationError,
    ActiveRecord::RecordNotUnique
  ].freeze

  def self.with_retry
    attempts ||= Concurrent::ThreadLocalVar.new(0)
    yield
  rescue *ERRORS => e
    attempts.value += 1
    raise e if attempts.value >= MAX_TRIES

    retry
  end
end
