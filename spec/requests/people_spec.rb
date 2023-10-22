# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'People', type: :request do
  let(:person_params) do
    { person:
      {
        firstname: 'Juliette',
        email: 'ju@gmail.com'
      } }
  end
  let(:invalid_attributes) do
    { person:
      {
        manager_name: 'jean'
      } }
  end
  let(:person) do
    Person.create(id: '1323', reference: 2, firstname: 'Amandyne', lastname: 'Verdonck', email: 'av@gmail.com')
  end

  describe 'PUT #update' do
    context 'awith valid params' do
      it 'update person' do
        put "/people/#{person.id}", params: person_params
        person.reload

        expect(person.firstname).to eq(person_params[:person][:firstname])
      end

      it 'redirect to show' do
        put "/people/#{person.id}", params: person_params
        expect(response).to redirect_to(person)
      end

      it 'show a succedd message' do
        put "/people/#{person.id}", params: person_params
        expect(flash[:notice]).to eq('La personne a bien été ajoutée.')
      end
    end

    context 'with invalid params' do
      it 'do not update person' do
        put "/people/#{person.id}", params: invalid_attributes

        expect(response).to have_http_status(302)
        expect(person).to eq(person)
      end
    end
  end
end
