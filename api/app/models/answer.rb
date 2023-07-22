# frozen_string_literal: true

class Answer < ApplicationRecord
  validates :text, presence: true

  belongs_to :question
end
