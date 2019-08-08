class Post < ApplicationRecord
  include PgSearch::Model
  multisearchable :against => [:title, :content]
  pg_search_scope :text_search, against: [:title, :content]

  belongs_to :updateable, polymorphic: true
  belongs_to :user

  validates :title, :type, :date, :content, presence: true

  def self.types
    ["ActionTaken", "Observation", "Diagnosis", "ClientFollowUp", "TechnicianNote"]
  end

  def self.diagnosis
    where(type: "Diagnosis")
  end

  def self.actions_taken
    where(type: 'ActionTaken')
  end
end
