class EmployeePolicy < ApplicationPolicy
  def show?
    user.proprietor?
  end
  def edit?
    user.proprietor?
  end
  def update?
    edit?
  end
end