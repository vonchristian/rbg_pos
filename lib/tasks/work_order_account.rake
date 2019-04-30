namespace :work_orders do
  desc "Create work order accounts"
  task create_account: :environment do
    WorkOrder.all.each do |work_order|
      AccountCreators::WorkOrder.new(work_order: work_order).create_accounts!
    end
  end
  task migrate_entries: :environment do
    WorkOrder.all.each do |work_order|
      WorkOrders::EntryMigrator.new(work_order: work_order).migrate_entries!
    end
  end
end
