class StockInventoryJob
  include Sidekiq::Worker
  sidekiq_options queue: 'high'

  def perform(options = {})
    stocks = options.fetch(:stocks)
    path = "#{Rails.root.to_s}/tmp/#{filename(options[:name])}"

    attributes = %w{name barcode purchase_quantity sales_balance stock_transfers_balance spoilage_balance internal_uses_balance purchase_returns_balance available_quantity}


    CSV.open(path, 'wb', headers: true) do |csv|
      csv << attributes

      stocks.each do |stock|
        csv << attributes.map{ |attr| stock.send(attr) }
      end
    end
  end

  private

  def filename(model)
    [model.to_s.try(:downcase), Time.current.try(:to_i)].join('_') + '.csv'
  end
end
