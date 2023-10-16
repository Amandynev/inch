
require 'rails_helper'

RSpec.describe ImportService do
  describe '.import' do
    let(:model_class) { 'Person' }
    let(:import_fields) { %w(email home_phone_number mobile_phone_number address) }
    let(:col_sep) { ';' }
    let(:file) { double('File', open: 'csv_data') }
    let(:csv) { double('CSV', each: csv_data) }
    let(:csv_data) do
      [
        { 'email' => 'test@example.com', 'home_phone_number' => '12345', 'mobile_phone_number' => '67890', 'address' => '123 Main St' },
        { 'email' => 'another@example.com', 'home_phone_number' => '55555', 'mobile_phone_number' => '99999', 'address' => '456 Elm St' }
      ]
    end

    before do
      allow(CSV).to receive(:parse).and_return(csv)
    end

    it 'imports data and returns results' do
      expect(File).to receive(:open).with(file, 'r').and_return(file)
      expect(ImportService).to receive(:create_or_update_model_klass).twice.and_return(double('Person', save: true, errors: []))
      results = ImportService.import(file, model_class, import_fields, col_sep)
      expect(results[:success]).to eq(2)
      expect(results[:failure]).to eq(0)
      expect(results[:errors]).to be_empty
    end

    it 'handles import errors and returns results' do
      expect(File).to receive(:open).with(file, 'r').and_return(file)
      expect(ImportService).to receive(:create_or_update_model_klass).twice.and_return(double('Person', save: false, errors: ['Email is invalid']))
      results = ImportService.import(file, model_class, import_fields, col_sep)
      expect(results[:success]).to eq(0)
      expect(results[:failure]).to eq(2)
      expect(results[:errors].size).to eq(2)
      expect(results[:errors][0][:errors]).to include('Email is invalid')
      expect(results[:errors][1][:errors]).to include('Email is invalid')
    end

    it 'handles import exceptions and returns results' do
      expect(File).to receive(:open).with(file, 'r').and_raise(StandardError, 'File not found')
      results = ImportService.import(file, model_class, import_fields, col_sep)
      expect(results[:success]).to eq(0)
      expect(results[:failure]).to eq(0)
      expect(results[:errors].size).to eq(1)
      expect(results[:errors][0]).to eq('File not found')
    end
  end

  describe '.create_or_update_model_klass' do
    it 'creates or updates a model instance' do
      model_class = double('Person')
      row = { 'email' => 'test@example.com', 'home_phone_number' => '12345' }
      expect(ImportService).to receive(:selected_attributes).and_return(['email', 'home_phone_number'])
      expect(model_class).to receive(:find_or_initialize_by).and_return(double('Person', save: true))
      object = ImportService.create_or_update_model_klass(model_class, ['email'], row)
      expect(object.save).to be(true)
    end
  end

  describe '.selected_attributes' do
    it 'returns selected attributes for Person' do
      attributes = ImportService.selected_attributes('Person')
      expect(attributes).to eq(['email', 'home_phone_number', 'mobile_phone_number', 'address'])
    end

    it 'returns selected attributes for other models' do
      attributes = ImportService.selected_attributes('OtherModel')
      expect(attributes).to eq(['manager_name'])
    end
  end
end
