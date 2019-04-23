module StoreFrontModule
  class SellingPricePolicy < ApplicationPolicy
    def new?
      user.proprietor?
    end
    def create?
      new?
    end
  end
end
