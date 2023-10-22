# frozen_string_literal: true

# building controller
class BuildingsController < ApplicationController
  def index
    @buildings = Building.all
  end

  def update
    valid_params = building_params.select do |key, _value|
      BuildingAudit.column_names.include?(key)
    end

    if BuildingAudit.where(valid_params).exists?
        building.reference = building_params[:reference]
        building.lastname = building_params[:lastname]
        building.firstname = building_params[:firstname]
        building.email = valid_params.email
        building.home_phone_number = valid_params.home_phone_number
        building.mobile_phone_number = valid_params.mobile_phone_number
        building.address = valid_params.address
        building.save
        redirect_to building, notice: "L'immeuble' a bien été ajoutée."
      end

    else

      buildingAudit.create(valid_params)
      if building.update(building_params)
        redirect_to building, notice: "L'immeuble'a bien été ajoutée."
      else
        flash.now[:alert] = "La mise à jour a échoué veuillez recommencer"
      end

    end
  end

  def import
    file = import_file_params
    unless file.present? && file.content_type == 'text/csv'
      return render status: 400,
                    json: { message: 'Invalid import template' }
    end

    import_name = Building
    import = ImportService.import(file, import_name, Building::HEADERS)

    if (import[:success]).positive?
      redirect_to buildings_path,
                  notice: "L'import est terminé avec succès. #{import[:success]} enregistrements importés."
    else
      redirect_to new_building_path, notice: "L'import a échoué. #{import[:failure]} enregistrements en erreur."
    end
  end

  private

  def building
    @building ||= Building.find params[:id] || params[:person_id]
  end

  def import_file_params
    params.require(:file)
  end

  def building_params
    params.require(:building).permit(
      :reference,
      :lastname,
      :city,
      :country,
      :manager_name,
      :zip_code,
      :address
    )
  end
end
