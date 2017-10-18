class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :branch, optional: true
  has_many :orders, foreign_key: 'employee_id'
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
  def full_name 
  	"#{first_name} #{last_name}"
  end
   def fund_transfer_total
    fund_transfers.fund_transfer.map{ |a| a.debit_amounts.distinct.sum(:amount) }.sum
  end
  def cash_on_hand_account
    if proprietor?
      AccountingModule::Asset.find_by(name: "Cash on Hand")
    elsif sales_clerk?
      AccountingModule::Asset.find_by(name: "Cash on Hand (Cashier)")
    end 
  end 
end
