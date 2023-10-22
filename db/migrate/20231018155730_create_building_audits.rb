class CreateBuildingAudits< ActiveRecord::Migration[7.0]
  def change
    create_table :building_audits do |t|
      t.string :manager_name

      t.timestamps
    end
  end
end
