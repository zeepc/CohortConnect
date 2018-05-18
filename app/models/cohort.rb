class Cohort < ApplicationRecord
  has_many :cohort_users
  has_many :users, through: :cohort_users
end
