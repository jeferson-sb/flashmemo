# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:score) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:exam) }
  end

  describe 'attempt' do
    describe 'when interval level is already at maximum' do
      let(:answer) { create(:answer) }

      it 'does not increment interval level' do
        answer.interval_level = 3
        answer.attempt
        expect(answer.interval_level).to be <= 3
      end
    end

    describe 'when score is 100 or greater' do
      let(:answer) { create(:answer) }

      it 'does not increment interval level' do
        answer.score = 100
        answer.attempt
        expect(answer.interval_level).to be 0
      end
    end

    describe 'when score is less than 100 and interval level is less than maximum' do
      let(:answer) { create(:answer) }

      it 'increments interval level' do
        answer.attempt
        expect(answer.interval_level).to be 1
      end

      it 'saves answer attempt' do
        answer.attempt
        expect(answer.last_attempted_at).to_not be nil
        expect(answer.interval_level).to be 1
      end
    end
  end

  describe 'valid_interval' do
    describe 'when last_attempted_at is within interval' do
      let(:answer) { create(:answer) }
  
      it 'returns true' do
        answer.interval_level = 1
        answer.last_attempted_at = 3.days.ago

        expect(answer.last_attempted_at).to_not be nil
        expect(answer.valid_interval?).to be true
      end
    end

    describe 'when last_attempted_at is NOT within interval' do
      let(:answer) { create(:answer) }
  
      it 'returns false' do
        answer.interval_level = 1
        answer.last_attempted_at = 2.days.ago

        expect(answer.last_attempted_at).to_not be nil
        expect(answer.valid_interval?).to be false
      end
    end
  end
end
