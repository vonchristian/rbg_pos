module Suppliers
  class AccountMergingForm
    include ActiveModel::Model
    include ActiveModel::Validations
    attr_accessor :old_supplier_id, :new_supplier_id
    validates :old_supplier_id, :new_supplier_id, presence: true
    validate :not_the_same_supplier?
    def save
      ActiveRecord::Base.transaction do
        merge_account
      end
    end
    private
    def merge_account
      old_supplier = Supplier.find_by_id(old_supplier_id)
      new_supplier = Supplier.find_by_id(new_supplier_id)
      new_supplier.delivered_stocks << old_supplier.delivered_stocks
      new_supplier.payments << old_supplier.payments
      old_supplier.destroy
    end
    def not_the_same_supplier?
      errors[:old_supplier_id] << "Cannot be the same supplier" if self.old_supplier_id == new_supplier_id
    end
  end
end
