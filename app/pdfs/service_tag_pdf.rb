require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'
class ServiceTagPdf < Prawn::Document
  def initialize(work_order, view_context)
    super(margin: 40, page_size: 'A4')
    @work_order = work_order
    @view_context = view_context
    heading
    barcode
    customer_details
    product_details
    if @work_order.under_warranty?
      warranty_details
    end
    reported_problem
    message
  end

  private
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def barcode

      bounding_box [340, 770], width: 180 do
        text "SERVICE CLAIM FORM", size: 15
        move_down 40
        barcode = Barby::Code39.new(@work_order.service_number)
        barcode.annotate_pdf(self, height: 40)
        move_down 3
        text  "##{@work_order.service_number}", size: 18, style: :bold

      end
    end
  def heading
    bounding_box [0, 780], width: 300 do
      image "#{Rails.root}/app/assets/images/letterhead.jpg", width: 320, height: 80
    end
  end
  def customer_details
    move_down 20
    text "CUSTOMER DETAILS", style: :bold
    move_down 2
    table(customer_details_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [2,0,0,0]}, column_widths: [20, 150, 150]) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
    end
    move_down 5
    stroke_horizontal_rule
  end
  def customer_details_data
    @customer_details_data ||=  [["","Customer",  "<b>#{@work_order.customer_full_name.try(:upcase)}</b>"]] +
                                [["", "Contact Person", "#{@work_order.contact_person}"]] +
                                [["", "Address", "#{@work_order.customer_address}"]] +
                                [["", "Contact NUmber",  "#{@work_order.customer_contact_number}"]]
  end
  def product_details
    move_down 5
    text "PRODUCT DETAILS", style: :bold
    table(product_details_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [3,0,0,0]}, column_widths: [20, 150, 200]) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
    end
    move_down 5
    stroke_horizontal_rule
    move_down 5
  end
  def product_details_data
    @product_details_data ||=   [["", "Date Received",  "#{@work_order.created_at.strftime("%B %e, %Y")}"]] +
                                [["", "Description",  "#{@work_order.description}"]] +
                                [["", "Model Number", "#{@work_order.model_number.try(:upcase)}"]] +
                                [["", "Serial Number", "#{@work_order.serial_number.try(:upcase)}"]] +
                                [["", "Physical Condition", "#{@work_order.physical_condition}"]] +
                                [["", "<b>ACCESSORIES</b>"]] +
                                @work_order.accessories.map{|a| ["","", "#{a.quantity.to_i} - #{a.description} <i>(#{a.serial_number})</i>"] }
  end
  def warranty_details
    text "WARRANTY DETAILS", style: :bold, size: 10
    table(warranty_details_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [3,0,0,0]}, column_widths: [20, 150, 200]) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
    end
    move_down 5
    stroke_horizontal_rule
    move_down 5
  end
  def warranty_details_data
    @warranty_details_data ||= [["", "Supplier", "#{@work_order.supplier.try(:business_name)}"]] +
                               [["", "Purchase Date", "#{@work_order.purchase_date.strftime("%B %e, %Y")}"]] +
                               [["", "Warranty Expiry Date", "#{@work_order.expiry_date.strftime("%B %e, %Y")}"]]

  end

  def reported_problem
    text "REPORTED PROBLEM", style: :bold
    table(reported_problem_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [3,0,0,0]}, column_widths: [20, 150, 200]) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
    end
    move_down 5
    stroke_horizontal_rule
    move_down 5
  end
  def reported_problem_data
    @reported_problem_data ||= [["", "", "#{@work_order.reported_problem}"]]
  end
  def message
    move_down 10

  end
end
