# frozen_string_literal: true

class BuildingAudit < ApplicationRecord
  validates_uniqueness_of :manager_name
end
