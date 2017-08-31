class OrderPdf < Prawn::Document 
	def initialize(order, view_context)
      super(margin: 30, page_size: 'A4')
		@order = order 
		@view_context = view_context
		heading
		customer
		line_items
	end 
	
	private
	def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
	def heading 
		text "Order Details", align: :center
		move_down 5
		stroke_horizontal_rule
		move_down 10
	end
	def customer 
		text "Customer:                  #{@order.customer.full_name}"
		text "Date:                          #{@order.date.strftime("%B %e, %Y")}"
		if @order.stock_transfer?
		  text "Order Type:                #{@order.mode_of_payment.try(:titleize)}"
		else
		  text "Mode of Payment:     #{@order.mode_of_payment.try(:titleize)}"
		end
		text "Number of Items:      #{@order.line_items.count}"
		move_down 5
		# text "Total Cost:                  #{price(@order.total_cost)}"
		# text "Discount:                    #{price(@order.discount_amount)}"
		# text "Total Cost Less Discount                   #{price(@order.total_cost_less_discount)}"
	end
	def line_items
      move_down 10 
        table line_items_data,  
      cell_style: { size: 11,  inline_format: true  }, column_widths: [170, 80, 80, 100, 100] do
        row(0).font_style = :bold
        column(3).align = :right
        column(4).align = :right
      end
    end

    def line_items_data 
      [["PRODUCT", "BARCODE", "QUANTITY", "UNIT COST", "TOTAL COST"]] +
      @line_items_data ||= @order.line_items.map{|e| [e.stock.try(:name), e.stock.try(:barcode), e.quantity,price(e.unit_cost), price(e.total_cost)] } +
      [["TOTAL", "", "", "", "#{price(@order.total_cost)}"]]
    end

end 