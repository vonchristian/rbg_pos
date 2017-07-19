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
    def heading
      text 'SALES REPORT', align: :center, style: :bold
      if @from_date && @to_date
        text "From: #{@from_date.strftime('%B %e, %Y')} To: #{@to_date.strftime('%B %e, %Y')} ", align: :center
      end
      move_down 5
      stroke_horizontal_rule
    end 
    def orders_table
      move_down 10 
        table(orders_data, header: false,  cell_style: { size: 10, font: "Helvetica", :inline_format => true}) do
      end
    end
    def orders_data 
      [["DATE", "CUSTOMER", "MODE OF PAYMENT", "DISCOUNT", "TOTAL COST", "TOTAL COST LESS DISCOUNT"]] +
      @orders_data ||= @orders.map{|o| [o.date.strftime("%B %e, %Y"), o.customer_full_name.upcase, o.mode_of_payment, price(o.discount_amount), price(o.total_cost), price(o.total_cost_less_discount)] }
    end
  end 
end