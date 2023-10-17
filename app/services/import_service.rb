require 'csv'

class ImportService
  class << self
    def import(file, model_class, import_fields, col_sep = ';')
      results = { success: 0, failure: 0, errors: [] }

      begin
        csv = CSV.parse(file.open, headers: true, col_sep: col_sep)

        csv.each do |row|

          create_or_update_model_klass(model_class, import_fields, row)

          if @object.save

            results[:success] += 1
          else
            results[:failure] += 1
            results[:errors] << { row: row, errors: @object.errors.full_messages }
          end
        end

        results
      rescue StandardError => e
        puts "An error occurred: #{e.message}"
        { success: 0, failure: 0, errors: [e.message] }
      end
    end

    private

    def create_or_update_model_klass(model_class, import_fields, row)
      selected_fields = selected_attributes(model_class)
      @object = model_class.find_or_initialize_by(selected_fields.map { |field| [field, row[field]] }.to_h)

      import_fields.each do |field|
        @object.send("#{field}=", row[field])
      end

    end

    def selected_attributes(model_class)
      if model_class == Person
        ['email','home_phone_number','mobile_phone_number', 'address']
      else
        ['manager_name']
      end
    end
  end
end
