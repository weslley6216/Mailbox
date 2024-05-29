class Mailbox < ApplicationRecord
  belongs_to :domain

  validates :username, :password, presence: true
end
