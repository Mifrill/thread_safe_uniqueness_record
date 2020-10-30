require 'nulldb_rspec'

RSpec.describe ThreadSafeUniquenessRecord do
  it "has a version number" do
    expect(ThreadSafeUniquenessRecord::VERSION).not_to be nil
  end

  describe ThreadSafeUniquenessRecord::Executer do
    include NullDB::RSpec::NullifiedDatabase

    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end

    subject(:uniqueness_record) do
      described_class.new(
        model_klass: model_klass,
        attributes: attributes
      )
    end

    let(:model_klass) { ApplicationRecord }
    let(:model) { instance_double model_klass }
    let(:attributes) { {} }

    context 'when raises ActiveRecord::RecordNotUnique in thread race' do
      let(:error) { ActiveRecord::RecordNotUnique.new }

      it 'founds by second attempt' do
        call_count = 0
        expect(model_klass).to receive(:find_or_create_by!).with({}) do
          call_count += 1
          (call_count == 1) ? (raise error) : model
        end.twice
        expect(uniqueness_record.find_or_create!).to eq(model)
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

        stub_const('FakeUniquenessRecord', Class.new(ApplicationRecord))
      end

      let(:model_klass) { FakeUniquenessRecord }
      let(:attributes) do
        {
          field: 'value',
        }
      end

      after do
        migration = ActiveRecord::Migration.new
        migration.verbose = false
        migration.drop_table :fake_uniqueness_records
      end

      it 'founds by second attempt' do
        expect { model_klass.create!(attributes) }.to change { model_klass.count }.from(0).to(1)
        call_count = 0
        expect(model_klass).to receive(:find_or_create_by!).with({ field: 'value' }) do
          call_count += 1
          if call_count == 1
            model_klass.create!(attributes)
          else
            model_klass.find_by!(attributes)
          end
        end.twice
        expect(uniqueness_record.find_or_create!).to eq(model_klass.first)
      end
    end
  end
end
