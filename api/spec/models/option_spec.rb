require 'rails_helper'

RSpec.describe Option, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:text) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:question) }
  end
end
