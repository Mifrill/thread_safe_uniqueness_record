describe ThreadSafeUniquenessRecord do
  it 'has a version number' do
    expect(ThreadSafeUniquenessRecord::VERSION).not_to be nil
  end

  describe ThreadSafeUniquenessRecord::FindOrCreateBy do
    let(:application_record) do
      Class.new(ActiveRecord::Base) do
        self.abstract_class = true
      end
    end

    subject(:uniqueness_record_find_or_create!) do
      described_class.call(
        model_klass: model_klass,
        attributes: attributes
      )
    end

    let(:model_klass) { application_record }
    let(:model) { instance_double model_klass }
    let(:attributes) { {} }

    context 'when raises ActiveRecord::RecordNotUnique in thread race' do
      let(:error) { ActiveRecord::RecordNotUnique.new }

      it 'founds by second attempt' do
        call_count = 0
        expect(model_klass).to receive(:find_or_create_by!).with({}) do
          call_count += 1
          call_count == 1 ? (raise error) : model
        end.twice
        expect(uniqueness_record_find_or_create!).to eq(model)
      end

      context 'when MAX_TRIES is reached' do
        it 'throws exception' do
          expect(model_klass).to receive(:find_or_create_by!).with({}) do
            raise error
          end.exactly(3)
          expect { uniqueness_record_find_or_create! }.to raise_exception(error)
        end
      end
    end

    context 'when raises ActiveRecord::RecordInvalid in thread race' do
      before do
        migration = ActiveRecord::Migration.new
        migration.verbose = false
        migration.create_table :fake_uniqueness_records do |t|
          t.string :field
        end
        migration.add_index :fake_uniqueness_records, :field, unique: true

        stub_const('FakeUniquenessRecord', Class.new(application_record))
      end

      let(:model_klass) { FakeUniquenessRecord }
      let(:attributes) { { field: 'value' } }

      after do
        migration = ActiveRecord::Migration.new
        migration.verbose = false
        migration.drop_table :fake_uniqueness_records
      end

      it 'founds by second attempt' do
        expect { model_klass.create!(attributes) }.to change { model_klass.count }.from(0).to(1)
        call_count = 0
        expect(model_klass).to receive(:find_or_create_by!).with(hash_including(field: 'value')) do
          call_count += 1
          if call_count == 1
            model_klass.create!(attributes)
          else
            model_klass.find_by!(attributes)
          end
        end.twice
        expect do
          expect(uniqueness_record_find_or_create!).to eq(model_klass.first)
        end.to not_change { model_klass.count }
      end

      context 'when creation failed with not "RecordInvalid" reason' do
        let(:attributes) { { field: nil } }

        it 'raises proper exception without attempts' do
          migration = ActiveRecord::Migration.new
          migration.verbose = false
          migration.change_column_null :fake_uniqueness_records, :field, false
          expect(model_klass).to receive(:find_or_create_by!).with(hash_including(field: nil)).once.and_call_original
          expect { uniqueness_record_find_or_create! }.to raise_exception(ActiveRecord::NotNullViolation)
        end
      end

      context 'when Validation failed by not "taken" reason' do
        let(:application_record) do
          Class.new(ActiveRecord::Base) do
            self.abstract_class = true
            validates :field, presence: true
          end
        end
        let(:attributes) { { field: '' } }

        it 'raises RecordInvalid exception without attempts' do
          expect(model_klass).to receive(:find_or_create_by!).with(hash_including(field: '')).once.and_call_original
          expect { uniqueness_record_find_or_create! }.to raise_exception(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
