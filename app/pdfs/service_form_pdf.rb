require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
class ServiceFormPdf < Prawn::Document 
  def initialize(work_order, view_context)
    super(margin: 50, page_size: 'A4')
    @work_order = work_order
    @view_context = view_context
    heading
    barcode
    customer_details
    product_details
    diagnosis_details
    actions_taken_details
    charges_details
    spare_parts_details
    summary_details
  end 
  
  private
  def price(number)
    @view_context.number_to_currency(number, :unit => "P ")
  end
  def barcode
      bounding_box [300, 700], width: 140 do
        barcode = Barby::Code39.new(@work_order.service_number)
        barcode.annotate_pdf(self, height: 50)
        move_down 3
        text "SERVICE NUMBER: #{@work_order.service_number}", size: 8
        move_down 5
      end
    end
  def heading 
    text "SERVICE FORM"
    move_down 40
    stroke_horizontal_rule
  end
  def customer_details 
    move_down 5
    text "CUSTOMER DETAILS", style: :bold
    move_down 10
    table(customer_details_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [3,0,0,0]}, column_widths: [20, 150, 150]) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
    end
    move_down 10
    stroke_horizontal_rule
  end
  def customer_details_data
    @customer_details_data ||=  [["","Customer",  "#{@work_order.customer_full_name}"]] +
                                [["", "Address", "#{@work_order.customer_address}"]] +
                                [["", "Contact NUmber",  "#{@work_order.customer_contact_number}"]]
  end
  def product_details 
    move_down 15
    text "PRODUCT DETAILS", style: :bold
    move_down 10
    table(product_details_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [3,0,0,0]}, column_widths: [20, 150, 150]) do
        cells.borders = []
        # column(0).background_color = "CCCCCC"
    end
    move_down 5
    stroke_horizontal_rule
  end
  def product_details_data
    @product_details_data ||=  [["", "Description",  "#{@work_order.description}"]] +
                                [["", "Model Number", "#{@work_order.model_number.try(:upcase)}"]] +
                                [["", "Serial Number", "#{@work_order.serial_number.try(:upcase)}"]] + 
                                [["", "Physical Condition", "#{@work_order.physical_condition}"]] +
                                [["", "Reported Problem", "#{@work_order.reported_problem}"]]
  end
  def diagnosis_details
    move_down 15
    text "DIAGNOSIS", style: :bold
     move_down 10
    stroke_horizontal_rule
  end
  def actions_taken_details
    move_down 15
    text "ACTIONS TAKEN", style: :bold
     move_down 10
    stroke_horizontal_rule
  end
  def charges_details
    move_down 15
    text "SERVICE CHARGES", style: :bold
    if @work_order.service_charges.present?
      move_down 10
      table(charge_details_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [3,0,0,0]}, column_widths: [20, 150, 150]) do
          cells.borders = []
          # column(0).background_color = "CCCCCC"
      end
    end
    move_down 5
    stroke_horizontal_rule
  end
  def charge_details_data
    @charge_details_data ||= @work_order.service_charges.map{|a| ["", a.description, price(a.amount)] } +
    [["", "_____________________", "___________"]] +
    [["", "TOTAL", "#{price(@work_order.total_service_charges_cost)}"]]
  end
  def spare_parts_details
    move_down 15
    text "SPARE PARTS", style: :bold
    if @work_order.spare_parts.present?
      move_down 10
      table(spare_part_details_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [3,0,0,0]}, column_widths: [20, 50, 150, 150]) do
          cells.borders = []
          # column(0).background_color = "CCCCCC"
      end
    end
    move_down 5
    stroke_horizontal_rule
  end
  def spare_part_details_data
    @spare_part_details_data ||= @work_order.spare_parts.map{|a| ["", a.quantity, a.product_name, price(a.total_cost)] } +
    [["","___________", "_____________________", "______"]] +
    [["", "TOTAL", "#{price(@work_order.total_service_charges_cost)}"]]
  end
  def summary_details
    move_down 15
    text "SUMMARY", style: :bold
     move_down 10
    stroke_horizontal_rule
  end
end 
