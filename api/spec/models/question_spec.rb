require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question_no_options) { create(:question, :with_options) }

  describe 'validations' do
    # TODO: Add before_create validations
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:options) }
    it { is_expected.to have_and_belong_to_many(:exams) }
  end
end
