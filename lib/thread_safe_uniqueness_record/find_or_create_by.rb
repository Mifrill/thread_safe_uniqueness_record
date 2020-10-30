module ThreadSafeUniquenessRecord
  class FindOrCreateBy
    def self.call(model_klass:, attributes:)
      ThreadSafeUniquenessRecord.with_retry do
        ActiveRecord::Base.transaction(requires_new: true) do
          model_klass.find_or_create_by!(attributes)
        end
      end
    end
  end
end
