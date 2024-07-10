# frozen_string_literal: true

class Domain < ApplicationRecord
  has_many :mailboxes

  validates :name, presence: true
  validates :password_expiration_frequency, presence: true, inclusion: { in: [30, 60, 90, 180] }
end
