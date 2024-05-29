class Domain < ApplicationRecord
  validates :domain_name, :password_expiration_frequency, presence: true

  has_many :mailboxes
end
