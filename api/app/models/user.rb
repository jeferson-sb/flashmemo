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
  has_many :exams, through: :answer
  has_many :mind_map
  has_one :garden
end
