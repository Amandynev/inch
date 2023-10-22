# frozen_string_literal: true

class CreatePersonAudits < ActiveRecord::Migration[7.0]
  def change
    create_table :person_audits do |t|
      t.string :email
      t.string :home_phone_number
      t.string :mobile_phone_number
      t.string :address

      t.timestamps
    end
  end
end
