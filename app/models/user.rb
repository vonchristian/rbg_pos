class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :branch, optional: true
  belongs_to :store_front, optional: true
  belongs_to :business, optional: true
  belongs_to :section, optional: true
  belongs_to :cash_on_hand_account, optional: true, class_name: "AccountingModule::Account"
  has_many :orders, foreign_key: 'employee_id'
  has_many :sales_orders, class_name: "StoreFrontModule::Orders::SalesOrder", foreign_key: 'employee_id'
  has_many :technician_work_orders, foreign_key: 'technician_id'
  has_many :work_orders, through: :technician_work_orders
  has_many :entries, class_name: "AccountingModule::Entry", foreign_key: 'recorder_id'
  has_many :fund_transfers, class_name: "AccountingModule::Entry", as: :commercial_document
  enum role: [:proprietor, :sales_clerk, :stock_custodian, :technician]
  has_attached_file :avatar,
  styles: { large: "120x120>",
           medium: "70x70>",
           thumb: "40x40>",
           small: "30x30>",
           x_small: "20x20>"},
  default_url: ":style/profile_default.jpg",
  :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
  :url => "/system/:attachment/:id/:style/:filename"
  do_not_validate_attachment_file_type :avatar
  delegate :balance, to: :default_cash_on_hand_account, prefix: true
  def self.cash_on_hand_accounts
    accounts = []
    self.all.each do |user|
      accounts << user.cash_on_hand_account
    end
    accounts.compact
  end

  def self.employee_for(cash_on_hand_account)
    where(cash_on_hand_account: cash_on_hand_account).first
  end

  def full_name
  	"#{first_name} #{last_name}"
  end
  def name
    full_name
  end
  def received_cash_transfers(options={})
    transfers = []
    cash_on_hand_account.debit_amounts.entered_on(options).each do |transfer|
      if User.cash_on_hand_accounts.include?(transfer.account) && transfer.commercial_document.is_a?(User)
        transfers << transfer
      end
    end
    transfers
  end

  def remittances(options={})
    remittances = []
    cash_on_hand_account.credit_amounts.entered_on(options).each do |remittance|
      if User.cash_on_hand_accounts.include?(remittance.account) && remittance.commercial_document.is_a?(User)
        remittances << remittance
      end
    end
    remittances
  end

  def cash_on_hand_account_balance
    default_cash_on_hand_account.balance(recorder_id: self.id)
  end

  def default_cash_on_hand_account
    if cash_on_hand_account.present?
      cash_on_hand_account
    else
      default_cash_on_hand_account_for(self)
    end
  end
  private
  def default_cash_on_hand_account_for(employee)
    if employee.proprietor?
      AccountingModule::Asset.find_by(name: "Cash on Hand")
    elsif employee.sales_clerk?
      AccountingModule::Asset.find_by(name: "Cash on Hand (Cashier)")
    end
  end
end
