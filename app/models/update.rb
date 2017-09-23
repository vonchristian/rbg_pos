class Update < ApplicationRecord
  belongs_to :updateable, polymorphic: true
  belongs_to :user
  validates :title, :type, :date, :content, presence: true
  def self.types 
    ["ActionTaken", "Observation", "Diagnosis", "ClientFollowUp"]
  end


end


