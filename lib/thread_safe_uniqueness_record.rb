require "thread_safe_uniqueness_record/version"
require "active_record"

module ThreadSafeUniquenessRecord
  class Error < StandardError; end

  class Executer
    # Usage is raised by thread race when the first thread tries to create
    # the record at the same time the second thread is trying to create exactly
    # the same record because both threads are seen no such record in DB
    # on find_by action by the passed attributes.
    # https://github.com/rails/rails/blob/24c1429a9e553196eb72312ec831afb6268222b1/activerecord/lib/active_record/relation.rb#L179-L222
    #
    # In thread race when both of threads proceed after the passed
    # uniqueness validation in model without raise of RecordInvalid error
    # and one of the thread has committed the change in DB then the second thread
    # fires the RecordNotUnique error with retry on the rescue.
    #
    # The attempts limiter is required to prevent the infinite loop when tries
    # to create the record which can't be found by the passed attributes but
    # becomes a duplicate by any other attributes.

    class UniquenessValidationError
      def self.===(exception)
        exception.is_a?(ActiveRecord::RecordInvalid) &&
          /Validation failed:.+\btaken\b/.match?(exception.message)
      end
    end

    MAX_TRIES = 3
    ERRORS = [
      UniquenessValidationError,
      ActiveRecord::RecordNotUnique,
    ].freeze

    def initialize(model_klass:, attributes:)
      self.model_klass = model_klass
      self.attributes = attributes
    end

    def find_or_create!
      attempts = 0
      with_retry(attempts: attempts) do
        attempts += 1
        ActiveRecord::Base.transaction(requires_new: true) do
          model_klass.find_or_create_by!(attributes)
        end
      end
    end

    private

    attr_accessor :model_klass, :attributes

    def with_retry(attempts:)
      yield
    rescue *ERRORS => e
      raise e if attempts >= MAX_TRIES

      retry
    end
  end
end
