module AccountingModule
  class WorkOrderPaymentForm
    include ActiveModel::Model
    attr_accessor :entry_date,
                  :reference_number,
                  :description,
                  :work_order_id,
                  :user_id,
                  :debit_account_id,
                  :credit_account_id,
                  :amount,
                  :discount_amount
    validates :entry_date, :description,  presence: true
    validates :amount, presence: true, numericality: true
    def save
      ActiveRecord::Base.transaction do
        create_entry
        create_order
      end
    end

    private
    def create_entry
      if discount_amount.to_f.zero?
        AccountingModule::Entry.work_order_payment.create!(recorder_id: user_id, commercial_document_id: work_order_id, commercial_document_type: "WorkOrder", entry_date: entry_date, reference_number: reference_number, description: description,
        credit_amounts_attributes: [amount: amount, account_id: credit_account_id],
        debit_amounts_attributes: [amount: amount, account_id: debit_account_id])
      elsif discount_amount.to_f > 0
        AccountingModule::Entry.work_order_payment.create!(recorder_id: user_id, commercial_document_id: work_order_id, commercial_document_type: "WorkOrder", entry_date: entry_date, reference_number: reference_number, description: description,
        credit_amounts_attributes:  [{amount: (amount.to_f + discount_amount.to_f), account_id: credit_account_id}],
        debit_amounts_attributes: [{amount: amount.to_f, account_id: debit_account_id}, {amount: discount_amount.to_f, account_id: discount_debit_account_id}])
      end
    end
    def discount_debit_account_id
      AccountingModule::Account.find_by(name: "Sales Discounts").id
    end
    def discount_credit_account_id
      AccountingModule::Asset.find_by(name: "Cash on Hand (Cashier)").id
    end
     def create_order
      order = Order.create!(description: "#{description} - Service Number ##{WorkOrder.find_by(id: work_order_id).service_number}", customer_id: WorkOrder.find_by(id: work_order_id).customer_id, date: entry_date, employee_id: user_id)
      Payment.create(mode_of_payment: 'cash', order: order, discount_amount: discount_amount, total_cost: amount.to_f + discount_amount.to_f, total_cost_less_discount: amount)
    end
  end
end
