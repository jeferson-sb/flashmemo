require 'rails_helper'

RSpec.describe Exam, type: :model do
  subject { create(:exam) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:difficulty) }
    it { is_expected.to validate_presence_of(:version) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe 'relations' do
    it { is_expected.to have_and_belong_to_many(:questions) }
  end 
end
