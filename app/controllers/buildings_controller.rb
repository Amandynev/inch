class BuildingsController < ApplicationController

  def index
    @buildings = Building.all
  end

  def update
    if building.update(building_params)
      redirect_to building, notice: 'La personne a bien été ajouté.'
    else
      render :edit
    end
  end

  def import
    file = import_file_params
    return render status: 400, json: { message: 'Invalid import template' } unless file.present? && file.content_type == 'text/csv'

    import_name = Building

    import = ImportService.import(file, import_name, Building::HEADERS)

    if import[:success] > 0
      redirect_to buildings_path, notice: "L'import est terminé avec succès. #{import[:success]} enregistrements importés."
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
      :address,
    )
  end
end
