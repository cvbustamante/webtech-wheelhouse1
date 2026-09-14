class StaffMember < ApplicationRecord
  has_many :repairs, foreign_key: "mechanic_id"
end
