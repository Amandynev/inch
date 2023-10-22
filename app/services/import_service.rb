# frozen_string_literal: true

require 'csv'

class ImportService
  class << self
    def import(file, model_class, import_fields, col_sep = ';')
      results = { success: 0, failure: 0, errors: [] }

      begin
        csv = CSV.parse(file.open, headers: true, col_sep:)
        csv.each do |row|
          create_and_track_model_klass(model_class, import_fields, row)
          if @object.save
            results[:success] += 1
          else
            results[:failure] += 1
            results[:errors] << { row:, errors: @object.errors.full_messages }
          end
        end

        results
      rescue StandardError => e
        puts "An error occurred: #{e.message}"
        { success: 0, failure: 0, errors: [e.message] }
      end
    end

    private

    def create_and_track_model_klass(model_class, import_fields, row)
      @object = if model_class == Person
                  Person.new
                else
                  Building.new
                end

      import_fields.each do |field|
        @object.send("#{field}=", row[field])
        track_history_changes(@object, field, row[field], model_class)
      end
    end

    def create_person(attribute_name, new_value)
      case attribute_name
      when 'reference'
        @object.reference = new_value
      when 'lastname'
        @object.address = new_value
      when 'firstname'
        @object.zip_code = new_value
      when 'email'
        @object.email = @history.email
      when 'home_phone_number'
        @object.home_phone_number = @history.home_phone_number
      when 'mobile_phone_number'
        @object.mobile_phone_number = @history.mobile_phone_number
      when 'address'
        @object.address = @history.address
      end
    end

    def create_building(attribute_name, new_value)
      case attribute_name
      when 'reference'
        @object.reference = new_value
      when 'address'
        @object.address = new_value
      when 'zip_code'
        @object.zip_code = new_value
      when 'city'
        @object.city = new_value
      when 'country'
        @object.country = new_value
      when 'manager_name'
        @object.manager_name = @history.manager_name
      end
    end

    def create_person_audit(attribute_name, new_value)
      return unless @history.respond_to?(attribute_name)
      return unless @history.public_send(attribute_name) != new_value

      @history.public_send("#{attribute_name}=", new_value)

      return unless @history.valid?

      @history.save

      create_person(attribute_name, new_value)
    end

    def create_building_audit(attribute_name, new_value)
      return unless @history.respond_to?(attribute_name)
      return unless @history.public_send(attribute_name) != new_value

      @history.public_send("#{attribute_name}=", new_value)
      return unless @history.valid?

      @history.save

      create_building(attribute_name, new_value)
    end

    def track_history_changes(_object, attribute_name, new_value, model_class)
      if model_class == Person
        excluding_attribute_name = %w[reference lastname firstname]

        return if excluding_attribute_name.include?(attribute_name)

        @history = PersonAudit.find_or_initialize_by("#{attribute_name}": new_value)

        create_person_audit(attribute_name, new_value)
      else
        excluding_attribute_name = %w[reference address zip_code city country]

        return if excluding_attribute_name.include?(attribute_name)

        @history = BuildingAudit.find_or_initialize_by("#{attribute_name}": attribute_name)

        create_building_audit(attribute_name, new_value)
      end
    end
  end
end
