require 'rails_helper'

describe Customer do
  it { is_expected.to belongs_to :business }
  it { is_expected.to have_many :orders }
  it { is_expected.to have_many :work_orders }
end
