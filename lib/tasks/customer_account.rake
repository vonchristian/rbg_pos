namespace :customers do
  desc "Create customer receivable accounts"
  task create_account: :environment do
    Customer.all.each do |customer|
      AccountCreators::Customer.new(customer: customer).create_account!
    end
  end
end
