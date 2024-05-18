# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DecayTreeHealthJob, type: :job do
  describe '#perform' do
    let!(:tree) { create(:tree) }

    it 'decrease health value' do
      expect { described_class.perform_now }.to change { tree.reload.health }.by(-1)
    end
  end
end
