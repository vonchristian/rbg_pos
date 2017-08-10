class Business < ApplicationRecord
	has_many :branches, dependent: :destroy
end
