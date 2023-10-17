class PeopleController < ApplicationController

  def index
    @people = Person.all
  end

  def new
    Person.new
  end

  def update
    if person.update(person_params)
      redirect_to person, notice: 'La personne a bien été ajoutée.'
    else
      flash.now[:alert] = "La mise à jour a échoué veuillez recommencer"
    end
  end

  def import
    file = import_file_params

    return render status: 400, json: { message: 'Invalid import template' } unless file.present? && file.content_type == 'text/csv'

    import_name = Person
    import = ImportService.import(file, import_name, Person::HEADERS)

    if import[:success] > 0
      redirect_to people_path, notice: "L'import est terminé avec succès. #{import[:success]} enregistrements importés."
    else
      flash.now[:alert] = "L'import a échoué. #{import[:failure]} enregistrements en erreur."
      render new_person_path
    end
  end

  private

  def person
    @person ||= Person.find params[:id] || params[:person_id]
  end

  def import_file_params
    params.require(:file)
  end

  def person_params
    params.require(:person).permit(
      :reference,
      :lastname,
      :firstname,
      :email,
      :home_phone_number,
      :mobile_phone_number,
      :address,
    )
  end
end