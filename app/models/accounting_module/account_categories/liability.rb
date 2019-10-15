module AccountingModule
  module AccountCategories
    class Liability < AccountingCategory

      self.normal_credit_balance = true

      def balance(options={})
        super
      end

      def self.balance(options={})
        super
      end
    end
  end
end
