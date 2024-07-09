class Mailbox < ApplicationRecord
  belongs_to :domain

  validates :username, :password, :scheduled_password_expiration, presence: true

  before_validation :hash_password, if: -> { password_changed? }
  before_validation :set_scheduled_password_expiration, if: -> { domain.present? && new_record? }

  def update_password(new_password)
    self.password = new_password
    self.scheduled_password_expiration = Time.current + domain.password_expiration_frequency.days
    save!
  end

  private

  def hash_password
    self.password = Digest::SHA512.hexdigest(password) if password.present?
  end

  def set_scheduled_password_expiration
    self.scheduled_password_expiration ||= Time.current + domain.password_expiration_frequency.days
  end
end
