class Update < ApplicationRecord
  belongs_to :updateable, polymorphic: true
  belongs_to :user
  def self.types 
    ["ActionTaken", "Observation", "Diagnosis", "ReportedProblem"]
  end
end


