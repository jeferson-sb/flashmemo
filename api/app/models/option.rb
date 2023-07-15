class Option < ApplicationRecord
  belongs_to :question

  validates :text, presence: true, uniqueness: { message: "Text already exists" }
  validates :correct, inclusion: { in: [true, false] }, allow_blank: true
end
