# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Edge, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:from_node_id) }
    it { is_expected.to validate_presence_of(:to_node_id) }
  end
end
