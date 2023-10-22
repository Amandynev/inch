# frozen_string_literal: true

class Person < ApplicationRecord
  HEADERS = %w[
    reference
    lastname
    firstname
    email
    home_phone_number
    mobile_phone_number
    address
  ].freeze
end
