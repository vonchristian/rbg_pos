class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :branch, optional: true
  enum role: [:proprietor, :sales_clerk, :stock_custodian]
  def full_name 
  	"#{first_name} #{last_name}"
  end
end
