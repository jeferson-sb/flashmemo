# frozen_string_literal: true

class MindMap < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
end
