require 'rails_helper'

RSpec.describe "People", type: :request do
  let(:person_params) {
    { person:
      {
        firstname: 'Juliette',
        email: 'ju@gmail.com',
      }
    }
  }
  let(:invalid_attributes) {
    { person:
      {
        manager_name: 'jean'
      }
    }
  }
  let(:person) { Person.create(id: "1323", reference: 2, firstname: "Amandyne", lastname: "Verdonck", email: "av@gmail.com") }

  describe "PUT #update" do
    context "awith valid params" do
      it "update person" do
        put "/people/#{person.id}", params: person_params
        person.reload

        expect(person.firstname).to eq(person_params[:person][:firstname])
      end

      it "redirect to show" do
        put "/people/#{person.id}", params: person_params
        expect(response).to redirect_to(person)
      end

      it "show a succedd message" do
        put "/people/#{person.id}", params: person_params
        expect(flash[:notice]).to eq('La personne a bien été ajoutée.')
      end
    end

    context "with invalid params" do
      it "do not update person" do
        result = put "/people/#{person.id}", params: invalid_attributes

        expect(response).to have_http_status(302)
        expect(person).to eq(person)
      end
    end
  end

end
