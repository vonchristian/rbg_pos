require 'rails_helper'

describe Customer do
  it { is_expected.to belong_to :business }
  it { is_expected.to belong_to(:receivable_account).optional }
  it { is_expected.to belong_to(:sales_revenue_account).optional }
  it { is_expected.to belong_to(:sales_discount_account).optional }
  it { is_expected.to belong_to(:service_revenue_account).optional }


  it { is_expected.to have_many :orders }
  it { is_expected.to have_many :work_orders }
  it { is_expected.to have_many :departments }
end
