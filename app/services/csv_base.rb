module CsvBase
  module CsvBase
    BOM = "\377\376".force_encoding('UTF-16LE')

    include Enumerable

    def each
      yield bom
      yield encoded(header)

      generate_csv do |row|
        yield encoded(row)
      end
    end

    def header
      ''
    end

    def bom
      ::CsvBase::CsvBase::BOM
    end

    private

    def encoded(string)
      string.encode('UTF-16LE', undef: :replace)
    end

    # WARNING: This will most likely NOT work on jruby!!!
    def generate_csv
      conn = ActiveRecord::Base.connection.raw_connection
      conn.copy_data(export_csv_query) do
        while row = conn.get_copy_data
          yield row.force_encoding('UTF-8')
        end
      end
    end

    def export_csv_query
      %Q{copy (#{export_sql}) to stdout with (FORMAT CSV, DELIMITER '\t', HEADER FALSE, ENCODING 'UTF-8');}
    end
  end
end
