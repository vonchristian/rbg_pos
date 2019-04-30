namespace :work_orders do
  desc "Create work order accounts"
  task create_account: :environment do
    WorkOrder.all.each do |work_order|
      AccountCreators::WorkOrder.new(work_order: work_order).create_account!
    end
  end

  task migrate_service_charge_entries: :environment do
    WorkOrder.all.each do |work_order|
      WorkOrders::EntryMigration.new(work_order: work_order).migrate_service_charge_entries!
    end
  end

  task migrate_spare_part_entries: :environment do
    WorkOrder.all.each do |work_order|
      WorkOrders::EntryMigration.new(work_order: work_order).migrate_spare_part_entries!
    end
  end
end
