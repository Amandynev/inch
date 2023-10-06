class CreatePersons < ActiveRecord::Migration[7.0]
  def change
    create_table :persons do |t|
      t.string :reference
      t.string :email
      t.string :home_phone_number
      t.string :mobile_phone_number
      t.string :firstname
      t.string :lastname
      t.string :address

      t.timestamps
    end
  end
end
