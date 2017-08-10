require 'rails_helper'

RSpec.describe LineItem, type: :model do
   it { is_expected.to have_one :refund }
end
