# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Revision, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:exam) }
  end
end
