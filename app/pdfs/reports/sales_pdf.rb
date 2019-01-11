module Reports
  class SalesPdf < Prawn::Document
    attr_reader :from_date, :to_date, :orders, :employee, :view_context
    def initialize(args)
      super(margin: 30, page_size: 'A4')
      @from_date    = args[:from_date]
      @to_date      = args[:to_date]
      @orders       = args[:orders]
      @employee     = args[:employee]
      @view_context = args[:view_context]
      heading
      cash_on_hand_account_details

      orders_table
    end
    private
    def price(number)
      @view_context.number_to_currency(number, :unit => "P ")
    end
    def order_description(order)
      if order.line_items.present?
        order.line_items_name
      elsif order.description.present?
        order.description
      end
    end
    def heading
      text 'SALES REPORT', align: :center, style: :bold
      if @from_date && @to_date && @from_date.strftime("%B %e, %Y") == @to_date.strftime("%B %e, %Y")
        text "Date: #{@from_date.strftime('%B %e, %Y')}", align: :center
      else
        text "From: #{@from_date.strftime('%B %e, %Y')} To: #{@to_date.strftime('%B %e, %Y')} ", align: :center
      end
      move_down 5
      stroke_horizontal_rule
    end
    def cash_on_hand_account_details
      if employee.present?
        table([["EMPLOYEE ", "#{employee.try(:name)}"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
        end

        table([["CASH ACCOUNT", "#{employee.cash_on_hand_account.try(:name)}"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
        end
        table([["BEGINNING BALANCE", "#{price employee.cash_on_hand_account.balance(to_date: Date.yesterday.end_of_day) + employee.received_cash_transfers(from_date: Date.today, to_date: Date.today).sum(&:amount)}"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
        end
        table([["ADD SALES", "#{price employee.cash_on_hand_account.debits_balance(from_date: Date.today, to_date: Date.today) - employee.received_cash_transfers(from_date: Date.today, to_date: Date.today).sum(&:amount) }"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
        end
        table([["LESS REMITTANCES", "#{price employee.cash_on_hand_account.credits_balance(from_date: Date.today, to_date: Date.today) }"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
        end
        stroke_horizontal_rule
        table([["<b>ENDING BALANCE</b>", "<b>#{price employee.cash_on_hand_account.balance}</b>"]], cell_style: { size: 9, font: "Helvetica", :inline_format => true}, column_widths: [120, 150, 150, 100]) do
          cells.borders = []
          row(0).text_color = "008751"
        end
      end
    end
    def orders_table
      move_down 10
      table(orders_data, header: false,  cell_style: { size: 9, font: "Helvetica", :inline_format => true}) do
      end
      move_down 10
    end
    def orders_data
      if @employee.present?
        [["DATE", "OR", "CUSTOMER", "ITEMS", "DISCOUNT", "TOTAL COST"]] +
        @orders_data ||= @employee.sales_orders.ordered_on(from_date: (@from_date.beginning_of_day), to_date: @to_date.end_of_day).map{|o| [o.date.strftime("%B %e, %Y"), o.reference_number, o.commercial_document.try(:name).try(:upcase), order_description(o), price(o.discount_amount), price(o.try(:total_cost))] } +
        [["", "","", "TOTAL", "#{price(@employee.sales_orders.ordered_on(from_date: (@from_date.beginning_of_day), to_date: @to_date.end_of_day).map{|a| a.total_cost}.to_a.compact.sum)}"]]
      else
         [["DATE", "OR", "CUSTOMER", "ITEMS", "DISCOUNT", "TOTAL COST"]] +
        @orders_data ||= @orders.ordered_on(from_date: (@from_date.beginning_of_day), to_date: @to_date.end_of_day).map{|o| [o.date.strftime("%B %e, %Y"), o.reference_number, o.commercial_document.try(:name).try(:upcase),  order_description(o),  price(o.discount_amount), price(o.try(:total_cost))] } +
        [["", "","", "", "<b>TOTAL</b>", "<b>#{price(@orders.to_a.map{|a| a.total_cost}.compact.sum)}</b>"]]
          end
    end

  end
end
