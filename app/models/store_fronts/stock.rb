module StoreFronts
  class Stock < ApplicationRecord
    belongs_to :product
  end
end
