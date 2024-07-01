class Domain < ApplicationRecord
  validates :name, :password_expiration_frequency, presence: true

  has_many :mailboxes
end
