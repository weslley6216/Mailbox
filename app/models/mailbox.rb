class Mailbox < ApplicationRecord
  attr_accessor :password

  belongs_to :domain

  validates :username, :password_digest, presence: true

  before_validation :hash_password, if: -> { password.present? }

  def update_password(new_password)
    self.password = new_password
    self.scheduled_password_expiration = Time.current + domain.password_expiration_frequency.days
    save!
  end

  private

  def hash_password
    self.password_digest = Digest::SHA512.hexdigest(password)
  end
end
