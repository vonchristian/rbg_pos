module Reports
  class CashReceiptsPdf < Prawn::Document
    def initialize(from_date, to_date, cash_receipts, employee, view_context)
      super(margin: 30, page_size: 'A4')
      @from_date = from_date
      @to_date = to_date
      @cash_receipts = cash_receipts
      @employee = employee
      @view_context = view_context
      heading
      cash_receipts_table
    end
    private
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end

    def heading
      text 'CASH RECEIPTS REPORT', align: :center, style: :bold
      if @from_date && @to_date && @from_date.strftime("%B %e, %Y") == @to_date.strftime("%B %e, %Y")
        text "Date: #{@from_date.strftime('%B %e, %Y')}", align: :center
      else
        text "From: #{@from_date.strftime('%B %e, %Y')} To: #{@to_date.strftime('%B %e, %Y')} ", align: :center
      end
      if @employee.present?
        text "Employee: #{@employee.try(:full_name)}"
      end
      move_down 5
      stroke_horizontal_rule
    end
    def cash_receipts_table
      move_down 10
      table(orders_data, header: false,  cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
      end
      move_down 10
    end
    def orders_data
        [["DATE", "CUSTOMER", "DESCRIPTION", "TOTAL COST"]] +
        @cash_receipts_data ||= @cash_receipts.map{|entry|
          [entry.entry_date.strftime("%B %e, %Y"),
           entry.commercial_document.try(:name).try(:upcase),
           entry.description,
           price(entry.total)] }+
        [["", "", "TOTAL", "#{price(@cash_receipts.sum(&:total))}"]]
    end

  end
end
