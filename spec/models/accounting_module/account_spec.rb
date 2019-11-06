require 'rails_helper'

module AccountingModule
  describe Account do
    describe 'associations' do
      it { is_expected.to belong_to :business }
      it { is_expected.to have_many :credit_amounts }
      it { is_expected.to have_many :debit_amounts }
      it { is_expected.to have_many :amounts }
      it { is_expected.to have_many :entries }
      it { is_expected.to have_many :credit_entries }
      it { is_expected.to have_many :debit_entries }
    end
    describe 'validations' do
      it { is_expected.to validate_presence_of :type }
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :account_code }
      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:business_id) }
      it { is_expected.to validate_uniqueness_of(:account_code).scoped_to(:business_id) }
    end

    describe '.scopes' do
      let(:asset)     { create(:asset) }
      let(:liability) { create(:liability) }
      let(:equity)    { create(:equity) }
      let(:revenue)   { create(:revenue) }
      let(:expense)   { create(:expense) }

      it '.assets' do
        expect(described_class.assets).to include(asset)
        expect(described_class.assets).to_not include(liability)
        expect(described_class.assets).to_not include(equity)
        expect(described_class.assets).to_not include(revenue)
        expect(described_class.assets).to_not include(expense)
      end

      it '.liabilities' do
        expect(described_class.liabilities).to_not include(asset)
        expect(described_class.liabilities).to include(liability)
        expect(described_class.liabilities).to_not include(equity)
        expect(described_class.liabilities).to_not include(revenue)
        expect(described_class.liabilities).to_not include(expense)
      end

      it '.equities' do
        expect(described_class.equities).to_not include(asset)
        expect(described_class.equities).to_not include(liability)
        expect(described_class.equities).to include(equity)
        expect(described_class.equities).to_not include(revenue)
        expect(described_class.equities).to_not include(expense)
      end

      it '.revenues' do
        expect(described_class.revenues).to_not include(asset)
        expect(described_class.revenues).to_not include(liability)
        expect(described_class.revenues).to_not include(equity)
        expect(described_class.revenues).to include(revenue)
        expect(described_class.revenues).to_not include(expense)
      end

      it '.expenses' do
        expect(described_class.expenses).to_not include(asset)
        expect(described_class.expenses).to_not include(liability)
        expect(described_class.expenses).to_not include(equity)
        expect(described_class.expenses).to_not include(revenue)
        expect(described_class.expenses).to include(expense)
      end
    end

    describe ".trial_balance" do
      subject { described_class.trial_balance }
      it { is_expected.to be_kind_of BigDecimal }

      context "when given no entries" do
        it { is_expected.to eql 0 }
      end

      context "when given correct entries" do
        before {
          business = create(:business)
          # credit accounts
          liability      = create(:liability, business: business)
          equity         = create(:equity, business: business)
          revenue        = create(:revenue, business: business)
          contra_asset   = create(:asset, :contra => true, business: business)
          contra_expense = create(:expense, :contra => true, business: business)
          # credit amounts
          ca1 = build(:credit_amount, :account => liability, :amount => 100000)
          ca2 = build(:credit_amount, :account => equity, :amount => 1000)
          ca3 = build(:credit_amount, :account => revenue, :amount => 40404)
          ca4 = build(:credit_amount, :account => contra_asset, :amount => 2)
          ca5 = build(:credit_amount, :account => contra_expense, :amount => 333)

          # debit accounts
          asset            = create(:asset, business: business)
          expense          = create(:expense, business: business)
          contra_liability = create(:liability, :contra => true, business: business)
          contra_equity    = create(:equity, :contra => true, business: business)
          contra_revenue   = create(:revenue, :contra => true, business: business)
          # debit amounts
          da1 = build(:debit_amount, :account => asset, :amount => 100000)
          da2 = build(:debit_amount, :account => expense, :amount => 1000)
          da3 = build(:debit_amount, :account => contra_liability, :amount => 40404)
          da4 = build(:debit_amount, :account => contra_equity, :amount => 2)
          da5 = build(:debit_amount, :account => contra_revenue, :amount => 333)

          create(:entry, :credit_amounts => [ca1], :debit_amounts => [da1])
          create(:entry, :credit_amounts => [ca2], :debit_amounts => [da2])
          create(:entry, :credit_amounts => [ca3], :debit_amounts => [da3])
          create(:entry, :credit_amounts => [ca4], :debit_amounts => [da4])
          create(:entry, :credit_amounts => [ca5], :debit_amounts => [da5])
        }

        it { is_expected.to eql 0 }
      end
    end


  end
end
