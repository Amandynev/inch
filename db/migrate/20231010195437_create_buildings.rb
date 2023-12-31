# frozen_string_literal: true

class CreateBuildings < ActiveRecord::Migration[7.0]
  def change
    create_table :buildings do |t|
      t.string :reference
      t.string :address
      t.string :zip_code
      t.string :city
      t.string :country
      t.string :manager_name

      t.timestamps
    end
  end
end
