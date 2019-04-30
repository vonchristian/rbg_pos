namespace :sales_orders do
  desc "Create sales order accounts"
  task create_accounts: :environment do
    StoreFrontModule::Orders::SalesOrder.all.each do |sales_order|
      AccountCreators::SalesOrder.new(sales_order: sales_order).create_accounts!
      puts 'Success'
    end
  end

  task migrate_entries: :environment do
    StoreFrontModule::Orders::SalesOrder.all.each do |sales_order|
      SalesOrders::EntryMigrator.new(sales_order: sales_order).migrate_entries!
      puts 'Success'
    end
  end
end
