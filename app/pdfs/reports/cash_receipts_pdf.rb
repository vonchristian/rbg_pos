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
      cash_on_hand_account_details
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

      move_down 5
      stroke_horizontal_rule
      move_down 10
    end
    def cash_on_hand_account_details
      if @employee.present?
        table([["EMPLOYEE ", "#{@employee.try(:name)}"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
        end

        table([["CASH ACCOUNT", "#{@employee.cash_on_hand_account.try(:name)}"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
        end
        table([["BEGINNING BALANCE", "#{price @employee.cash_on_hand_account.balance(to_date: Date.today.beginning_of_day)}"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
        end
        table([["ADD CASH TRANSFERS", "#{price @employee.cash_on_hand_account.debits_balance(from_date: Date.today.yesterday.end_of_day, to_date: Date.today.end_of_day)}"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
        end
        table([["LESS REMITTANCES", "#{price @employee.cash_on_hand_account.credits_balance(from_date: Date.today.yesterday.end_of_day, to_date: Date.today.end_of_day)}"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
          row(0).text_color = "FF0000"
        end
        stroke_horizontal_rule
        table([["<b>ENDING BALANCE</b>", "<b>#{price @employee.cash_on_hand_account.balance}</b>"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
          row(0).text_color = "008751"
        end
      end
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
