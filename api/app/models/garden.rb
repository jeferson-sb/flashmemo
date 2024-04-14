# frozen_string_literal: true

class Garden < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  has_many :trees
end
