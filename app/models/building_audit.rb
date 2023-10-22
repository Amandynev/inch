# frozen_string_literal: true

#  BuildingAudit model
class BuildingAudit < ApplicationRecord
  validates_uniqueness_of :manager_name
end
