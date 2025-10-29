# frozen_string_literal: true

class Profile < ApplicationRecord
  validates :settings, presence: true

  belongs_to :user
end
