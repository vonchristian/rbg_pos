module Reports
  class SalesPdf < Prawn::Document
    attr_reader :from_date, :to_date, :orders, :employee, :view_context, :business
    def initialize(args)
      super(margin: 30, page_size: 'A4')
      @from_date    = args[:from_date]
      @to_date      = args[:to_date]
      @orders       = args[:orders]
      @employee     = args[:employee]
      @business     = args[:business]
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
      bounding_box [360, 770], width: 200 do
        text "#{business.name.upcase }", style: :bold, size: 12
    end
    bounding_box [0, 770], width: 400 do
      text "SALES REPORT", style: :bold, size: 12
      text "Date Covered: #{from_date.strftime("%b. %e, %Y")} - #{to_date.strftime("%b. %e, %Y")}", size: 10
    end
      move_down 10
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
        @orders_data ||= @employee.sales_orders.ordered_on(from_date: (@from_date.beginning_of_day), to_date: @to_date.end_of_day).map{|o| [o.date.strftime("%B %e, %Y"), o.reference_number, o.commercial_document.try(:name).try(:upcase), order_description(o), price(o.discount_amount)] } +
        [["",
          "",
          "",
          "",
          "#{price(@employee.sales_orders.ordered_on(from_date: @from_date, to_date: @to_date).total_discount)}",
           "#{price(@employee.sales_orders.ordered_on(from_date: @from_date, to_date: @to_date).total_cost)}"]]
      else
         [["DATE", "OR", "CUSTOMER", "ITEMS", "DISCOUNT", "TOTAL COST", "INCOME"]] +
        @orders_data ||= @orders.ordered_on(from_date: (@from_date.beginning_of_day), to_date: @to_date.end_of_day).map{|o| [o.date.strftime("%B %e, %Y"), o.reference_number, o.commercial_document.try(:name).try(:upcase),  order_description(o),  price(o.discount_amount), price(o.try(:total_cost)), price(o.income)] } +
        [["", "","", "", "TOTAL", "<b>#{price(@orders.total_cost_less_discount)}</b>", "<b>#{price(@orders.total_income)}</b>"]]
          end
    end

  end
end
