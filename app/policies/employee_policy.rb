class EmployeePolicy < ApplicationPolicy
  def show?
    user.proprietor?
  end
end