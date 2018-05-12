module Reports
  class SalesPdf < Prawn::Document
    def initialize(from_date, to_date, orders, employee, view_context)
      super(margin: 30, page_size: 'A4')
      @from_date = from_date
      @to_date = to_date
      @orders = orders
      @employee = employee
      @view_context = view_context
      heading
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
      if @employee.present?
        text "Employee: #{@employee.try(:full_name)}"
      end
      move_down 5
      stroke_horizontal_rule
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
        @orders_data ||= @employee.orders.ordered_on(from_date: (@from_date.beginning_of_day), to_date: @to_date.end_of_day).map{|o| [o.date.strftime("%B %e, %Y"), o.reference_number, o.commercial_document.try(:name).try(:upcase), order_description(o), price(o.discount_amount), price(o.try(:total_cost))] } +
        [["", "","", "TOTAL", "#{price(@orders.sum(&:total_cost))}"]]
            else
         [["DATE", "OR", "CUSTOMER", "ITEMS", "DISCOUNT", "TOTAL COST"]] +
        @orders_data ||= @orders.ordered_on(from_date: (@from_date.beginning_of_day), to_date: @to_date.end_of_day).map{|o| [o.date.strftime("%B %e, %Y"), o.reference_number, o.commercial_document.try(:name).try(:upcase),  order_description(o),  price(o.discount_amount), price(o.try(:total_cost))] } +
        [["", "","", "", "<b>TOTAL</b>", "<b>#{price(@orders.sum(&:total_cost))}</b>"]]
          end
    end

  end
end
