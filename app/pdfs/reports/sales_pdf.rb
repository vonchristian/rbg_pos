module Reports
  class SalesPdf < Prawn::Document 
    def initialize(from_date, to_date, orders, view_context)
      super(margin: 30, page_size: 'A4')
      @from_date = from_date
      @to_date = to_date
      @orders = orders 
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
      move_down 5
      stroke_horizontal_rule
    end 
    def orders_table
      move_down 10 
        table(orders_data, header: false,  cell_style: { size: 9, font: "Helvetica", :inline_format => true}) do
           row(-1).font_style = :bold
           row(-1).background_color = "DDDDDD"
           row(-1).size = 10
      end
    end
    def orders_data 
      [["DATE", "CUSTOMER", "ITEMS", "MODE OF PAYMENT", "DISCOUNT", "TOTAL COST", "TOTAL COST LESS DISCOUNT"]] +
      @orders_data ||= @orders.map{|o| [o.date.strftime("%B %e, %Y"), o.customer.try(:full_name).try(:upcase), order_description(o), o.mode_of_payment, price(o.discount_amount), price(o.total_cost), price(o.total_cost_less_discount)] } +
      [["TOTAL", "", "", "", "#{price(@orders.total_discount_amount)}", "#{price(@orders.total_cost)}", "#{price(@orders.total_cost_less_discount)}"]]
    end
  end 
end