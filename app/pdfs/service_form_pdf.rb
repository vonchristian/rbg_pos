require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/prawn_outputter'
class ServiceFormPdf < Prawn::Document 
  def initialize(work_order, view_context)
    super(margin: 40, page_size: 'A4')
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

      bounding_box [340, 770], width: 150 do
        text "SERVICE FORM"
        move_down 40
        barcode = Barby::Code39.new(@work_order.service_number)
        barcode.annotate_pdf(self, height: 40)
        move_down 3
        text "SERVICE NUMBER: #{@work_order.service_number}", size: 8, style: :bold

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
    @customer_details_data ||=  [["","Customer",  "#{@work_order.customer_full_name}"]] +
                                [["", "Address", "#{@work_order.customer_address}"]] +
                                [["", "Contact NUmber",  "#{@work_order.customer_contact_number}"]]
  end
  def product_details 
    move_down 5
    text "PRODUCT DETAILS", style: :bold
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
    move_down 5
    text "DIAGNOSIS", style: :bold
    table(diagnosis_details_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [3,0,0,0]}, column_widths: [20, 150,  330]) do
        cells.borders = []
        column(0).size = 10
        # column(0).background_color = "CCCCCC"
    end
    move_down 5
    stroke_horizontal_rule
  end
  def diagnosis_details_data
    @diagnosis_details_data ||= @work_order.diagnoses.map{|a| ["", a.created_at.strftime("%b %e, %l:%M %p"),  a.content]}
  end
  def actions_taken_details
    move_down 5
    text "ACTIONS TAKEN", style: :bold
    table(actions_taken_details_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [3,0,0,0]}, column_widths: [20, 150,  330]) do
        cells.borders = []
        column(0).size = 10
        # column(0).background_color = "CCCCCC"
    end
    move_down 5
    stroke_horizontal_rule
  end
  def actions_taken_details_data
    @actions_taken_details_data ||= @work_order.actions_taken.map{|a| ["", a.created_at.strftime("%b %e, %l:%M %p"),  a.content]}
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
    [["","_______", "__________________", "___________"]] +
    [["", "TOTAL","",  "#{price(@work_order.total_spare_parts_cost)}"]]
  end
  def summary_details
    move_down 10
    text "SUMMARY", style: :bold
     move_down 5
      table(summary_data, cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [3,0,0,0]}, column_widths: [20, 200, 290]) do
          cells.borders = []
          row(-1).background_color = "FEC708"
          row(-1).size = 14
      end
      move_down 5
    stroke_horizontal_rule
  end
  def summary_data
    @summary_data ||=  [["", "TOTAL SERVICE CHARGES", "#{price(@work_order.total_service_charges_cost)}"]] +
                       [["", "TOTAL SPARE PARTS", "#{price(@work_order.total_spare_parts_cost)}"]] +
                       [["", "_________________________", "___________"]] +
                       [["", "<b>TOTAL</b>", "<b>#{price(@work_order.total_charges_cost)}</b>"]]


  end
end 
