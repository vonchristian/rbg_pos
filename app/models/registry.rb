require 'roo'
class Registry < ApplicationRecord
  belongs_to :employee, class_name: "User"
	has_attached_file :spreadsheet, :path => ":rails_root/public/system/:attachment/:id/:filename"
  do_not_validate_attachment_file_type :spreadsheet
  has_many :line_items, dependent: :destroy

end
