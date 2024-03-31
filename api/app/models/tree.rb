class Tree < ApplicationRecord
  belongs_to :garden

  enum :phase, %i[seed growing mature fall]

  scope :dry?, -> { where("health < 20") }
  scope :alive?, -> { where("health > 0") }

  validates :name, presence: true, uniqueness: true
  validates :health, presence: true
  validates :garden, presence: true

  has_many :branches
end
