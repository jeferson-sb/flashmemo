# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  normalizes :email, with: ->(e) { e.strip.downcase }

  has_many :sessions, dependent: :destroy
  has_many :answer
  # `exams` is the exams this user has *attempted*; authored_exams are the ones
  # they own and may edit.
  has_many :exams, through: :answer
  has_many :authored_exams, class_name: 'Exam', inverse_of: :user
  has_many :mind_map
  has_one :garden
  has_one :profile, dependent: :destroy
end
