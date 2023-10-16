class ImportService
  def import(file, model_class, import_fields, col_sep = ';')
    results = { success: 0, failure: 0, errors: [] }

    begin
      csv = CSV.parse(file.open, headers: true, col_sep: col_sep)

      csv.each do |row|
        object = model_class.find_or_initialize_by(import_fields.map { |field| [field, row[field]] }.to_h)

        import_fields.each { |field| object.send("#{field}=", row[field]) }

        if object.save
          results[:success] += 1
        else
          results[:failure] += 1
          results[:errors] << { row: row, errors: object.errors.full_messages }
        end
      end

      results
    rescue StandardError => e
      { success: 0, failure: 0, errors: [e.message] }
    end
  end
end
