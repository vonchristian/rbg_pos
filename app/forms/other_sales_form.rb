class OtherSalesForm
  include ActiveModel::Model
  attr_accessor :description, :reference_number, :recorder_id, :amount, :date, :customer_id, :sales_order_id
  validates :amount, :description, :customer_id, :date, presence: true

  def process!
    ActiveRecord::Base.transaction do
      create_order
    end
  end

  private
  def create_order
    order = StoreFrontModule::Orders::SalesOrder.new(
      description: description,
      commercial_document: find_customer,
      date: date,
      employee_id: recorder_id,
      reference_number: reference_number,
      store_front: find_employee.store_front,
      account_number: SecureRandom.uuid)
      create_accounts(order)
    order.save!
    order.create_cash_payment(cash_tendered: amount)

    create_voucher(order)
    create_entry(order)
  end


  def find_customer
    Customer.find(customer_id)
  end

  def find_employee
    User.find(recorder_id)
  end

  def create_voucher(order)
    Vouchers::OtherSalesOrderVoucher.new(order: order, employee: find_employee, amount: amount).create_voucher!
  end

  def create_entry(order)
    VoucherEntryCreation.new(voucher: order.voucher).create_entry!
  end
  def create_accounts(order)
    AccountCreators::SalesOrder.new(sales_order: order).create_accounts!
  end

end
