class Branch < ApplicationRecord
  belongs_to :business
  has_many :stock_transfers, foreign_key: 'destination_branch_id'
  validates :name, presence: true, uniqueness: true
end
