class Branch < ApplicationRecord
  belongs_to :tree

  validates :name, presence: true, uniqueness: true
  validates :tree, presence: true
end
