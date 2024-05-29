class Domain < ApplicationRecord
  validates :domain_name, presence: true

  has_many :mailboxes
end
