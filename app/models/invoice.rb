class Invoice < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :text_search, against: [:number]

  belongs_to :invoiceable, polymorphic: true
  delegate :name, to: :invoiceable, prefix: true
  delegate :customer_full_name, to: :invoiceable

  validates :number, presence: true
end
