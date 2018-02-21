FactoryBot.define do
  factory :selling_price, class: "StoreFrontModule::SellingPrice" do
    price "9.99"
    date "2018-02-10 06:18:25"
    product
  end
end
