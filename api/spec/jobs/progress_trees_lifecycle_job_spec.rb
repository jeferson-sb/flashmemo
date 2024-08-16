# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProgressTreesLifecycleJob, type: :job do
  describe '#perform' do
    describe 'when tree age < 30' do
      let(:tree) { create(:tree, created_at: 5.days.ago) }

      it 'seed -> growing' do
        expect { described_class.perform_now }.to change { tree.reload.phase }.to('growing')
      end
    end

    describe 'when tree age < 90' do
      let!(:tree) { create(:tree, created_at: 70.days.ago) }

      it 'growing -> mature' do
        expect { described_class.perform_now }.to change { tree.reload.phase }.to('mature')
      end
    end

    describe 'when tree age > 90' do
      let!(:tree) { create(:tree, created_at: 100.days.ago) }

      it 'mature -> fall' do
        expect { described_class.perform_now }.to change { tree.reload.phase }.to('fall')
      end
    end

    describe 'when tree age < 3' do
      let(:tree) { create(:tree, created_at: 2.days.ago) }

      it 'stay in seed phase' do
        expect { described_class.perform_now }.not_to change { tree.reload.phase }.from('seed')
      end
    end
  end
end
