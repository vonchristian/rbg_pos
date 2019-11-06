class OtherSalesController < ApplicationController
  def new
    @other_sale = OtherSalesForm.new
  end
  def create
    @other_sale = OtherSalesForm.new(other_sale_params)
    if @other_sale.valid?
      @other_sale.process!
      redirect_to store_index_url, notice: "Other Sales saved successfully"
    else
      render :new
    end
  end

  private
  def other_sale_params
    params.require(:other_sales_form).permit(:recorder_id, :amount, :reference_number, :description, :date, :recorder_id, :customer_id)
  end
end
