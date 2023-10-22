# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportService do
  let(:file) { double('file') }
  let(:model_class) { Person }
  let(:import_fields) do
    %w[
      reference
      lastname
      firstname
      email
      home_phone_number
      mobile_phone_number
      address
    ]
  end

  describe '.import' do
    let(:csv_data) { "email;home_phone_number;firstname;lastname\namandyne@gmail.com;0878908765;Amandyne;verdonck" }

    context 'when the import is successful for Person model' do
      it 'returns a success hash' do
        file = double('CSV file')
        allow(file).to receive(:open).and_return(StringIO.new(csv_data))

        result = ImportService.import(file, model_class, import_fields)
        expect(result[:success]).to eq(1)
        expect(result[:failure]).to eq(0)
      end
    end

    context 'when the import fails with wrong model_class' do
      let(:wrong_model_class) { 'People' }

      it 'returns a failure hash with an error message' do
        allow(file).to receive(:open).and_return(csv_data)

        result = ImportService.import(file, wrong_model_class, import_fields)
        expect(result[:errors]).to_not be_empty
      end
    end
  end
end
