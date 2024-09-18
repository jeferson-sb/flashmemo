# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MindMap, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:nodes) }
    it { is_expected.to belong_to(:category) }
  end
end
