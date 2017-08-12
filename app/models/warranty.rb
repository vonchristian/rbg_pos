class Warranty < ApplicationRecord
	include PgSearch
	pg_search_scope :text_search, against: [:name, :barcode, :remarks]

  belongs_to :sales_return
  belongs_to :supplier, optional: true
  belongs_to :customer
  has_one :warranty_release, dependent: :destroy
  def released?
  	warranty_release.present?
  end
end
