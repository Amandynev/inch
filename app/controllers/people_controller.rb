require 'csv'
class PeopleController < ApplicationController

  def index ;end

  def import
    # only csv ?
    file = import_file_params
    import_name = 'Person'
    file = File.open(file)
    csv = CSV.parse(file, headers: true, col_sep: ';')
    return render status: 400, json: { message: 'Invalid import template' } if csv.nil?

    klass_name = Object.const_get("Person")
    csv.each do |row|

     klass_name.find_or_initialize_by(
      email: row['email'],
      home_phone_number: row["home_phone_number"],
      mobile_phone_number: row["mobile_phone_number"],
      address: row["address"]
    ) do |person|
      binding.b
        person.reference = row["reference"],
        person.lastname = row["lastname"],
        person.firstname = row["firstname"],
        person.email = row["email"],
        person.home_phone_number = row["home_phone_number"],
        person.mobile_phone_number = row["mobile_phone_number"],
        person.address = row["address"]
        person.save
    end
      #

    end
    binding.b

    redirect_to people_path, notice: "L'import est terminé"
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
      render :index
    end
  end

  private

  def person
    @person ||= Person.find params[:id]
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
