# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tree, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:branches) }
  end

  describe '.dry?' do
    before { create(:tree, :dry) }

    it 'returns list of trees with low health' do
      expect(Tree.dry?.length).to eq(1)
    end
  end

  describe '.alive?' do
    before { create_list(:tree, 2) }

    it 'returns list of trees alive' do
      expect(Tree.alive?.length).to eq(2)
    end
  end
end
