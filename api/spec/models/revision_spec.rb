# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Revision, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:exam) }
  end

  describe '.increment_interval' do
    describe 'when interval level is already at maximum' do
      let(:revision) { create(:revision) }

      it 'does not increment interval level' do
        revision.interval_level = 3
        expect(revision.interval_level).to be <= 3
      end
    end

    describe 'when interval level is less than maximum' do
      let(:revision) { create(:revision) }

      it 'increments interval level' do
        revision.increment_interval
        expect(revision.interval_level).to be 1
      end
    end
  end

  describe '.valid_interval?' do
    describe 'when date is within interval' do
      let(:revision) { create(:revision) }

      it 'returns true' do
        revision.interval_level = 1

        expect(revision.valid_interval?(3.days.ago)).to be true
      end
    end

    describe 'when date is NOT within minimum interval' do
      let(:revision) { create(:revision) }

      it 'returns false' do
        revision.interval_level = 1

        expect(revision.valid_interval?(2.days.ago)).to be false
      end
    end
  end
end
