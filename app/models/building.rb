# frozen_string_literal: true

class Building < ApplicationRecord
  HEADERS = %w[
    reference
    address
    zip_code
    city
    country
    manager_name
  ].freeze
end
