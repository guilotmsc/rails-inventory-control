class CsvValidator

    def initialize(row)
        @csv_row = row
        @errors = []
    end
    
    def validate
        if !@csv_row.key?("Nome do depósito")
            @csv_row << 'Arquivo CSV inválido'
        end
    end

    def errors
        return @errors
    end

end