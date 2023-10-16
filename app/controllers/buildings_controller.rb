require 'csv'

class BuildingsController < ApplicationController

def index ;end

def import
  file = import_file_params
  return render status: 400, json: { message: 'Invalid import template' } unless file.present? && file.content_type == 'text/csv'

  import = ImportService.import(file, Building, Building::HEADERS)

  if import[:success] > 0
    redirect_to people_path, notice: "L'import est terminé avec succès. #{import[:success]} enregistrements importés."
  else
    flash.now[:alert] = "L'import a échoué. #{import[:failure]} enregistrements en erreur."
    render :index
  end
end

private

def import_file_params
  params.require(:file)
end

end