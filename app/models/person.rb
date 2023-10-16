class Person < ApplicationRecord

  HEADERS = %w[
    reference
    lastname
    firstname
    email
    home_phone_number
    modbile_phone_number
    address
  ]

  # self.class::HEADERS
#   def import_line(row)
#     binding.pry
#     self.find_or_initialize_by(
#       email: row['email'],
#       home_phone_number: row["home_phone_number"],
#       mobile_phone_number: row["mobile_phone_number"],
#       address: row["address"]

#     ) do |person|
#     # import_hash = {
#       person.reference = row["reference"],
#       person.lastname = row["lastname"],
#       person.firstname = row["firstname"],
#       person.email = row["email"],
#       person.home_phone_number = row["home_phone_number"],
#       person.mobile_phone_number = row["mobile_phone_number"],
#       person.address = row["address"]
#       person.save
#     # }
#   end
#     # @import_hash = import_hash
#   end
end
