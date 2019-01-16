require 'rails_helper'

describe Customer do
  it { is_expected.to belongs_to :business }
end
