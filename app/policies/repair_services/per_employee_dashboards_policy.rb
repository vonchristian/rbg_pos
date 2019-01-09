module RepairServices
  class PerEmployeeDashboardsPolicy < ApplicationPolicy
    def index?
      user.proprietor?
    end
  end
end
