class Transaction < ApplicationRecord
  validates :date, presence: true
  validates :amount, presence: true

  def self.get_transactions(current_user)
    return Transaction.where(user_id: current_user.id)
  end

end
