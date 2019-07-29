require 'rails_helper'

describe Product do
  describe 'associations' do
    it { is_expected.to belong_to :business }
    it { is_expected.to belong_to(:category).optional }
    it { is_expected.to have_many :line_items }
    it { is_expected.to have_many :orders }
    it { is_expected.to have_many :sales_returns }
    it { is_expected.to have_many :unit_of_measurements }
    it { is_expected.to have_many :purchases }
    it { is_expected.to have_many :internal_uses }
    it { is_expected.to have_many :sales }
    it { is_expected.to have_many :sales_orders }
    it { is_expected.to have_many :purchase_orders }
    it { is_expected.to have_many :sales_returns }
    it { is_expected.to have_many :purchase_returns }
    it { is_expected.to have_many :spoilages }
    it { is_expected.to have_many :selling_prices }
    it { is_expected.to have_many :purchase_prices }
    it { is_expected.to have_many :stocks }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:business_id) }
  end
end
