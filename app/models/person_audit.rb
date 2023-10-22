class PersonAudit < ApplicationRecord

  validates_uniqueness_of :email
  validates_uniqueness_of :home_phone_number
  validates_uniqueness_of :mobile_phone_number
  validates_uniqueness_of :address
end
