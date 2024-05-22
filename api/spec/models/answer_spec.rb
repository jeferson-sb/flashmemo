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

  describe '.last_attempted_over_a_day' do
    context 'when newly created' do
      let(:answer) { create(:answer) }
  
      it 'reject' do
        expect(answer.last_attempted_over_a_day?).to be false
      end
    end

    context 'when newly created' do
      let(:answer) { create(:answer, created_at: 2.days.ago) }
  
      it 'accept' do
        expect(answer.last_attempted_over_a_day?).to be true
      end
    end
  end
end
