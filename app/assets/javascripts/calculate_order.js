function calculateOrderTotalCost() {
  var discountAmount = document.getElementById('discount_amount').value;
  var totalCost = document.getElementById('total_cost').value;
  var cashTendered = document.getElementById('cash_tendered').value;

  var totalCostLessDiscountValue = document.getElementById('total_cost_less_discount').value;
  var totalCostLessDiscount = document.getElementById('total_cost_less_discount');
  var change = document.getElementById('change');
  var result = totalCost - discountAmount;
  var changeResult = cashTendered - result;
  change.value = changeResult;
  totalCostLessDiscount.value = result;
}