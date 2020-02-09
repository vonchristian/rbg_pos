require 'rails_helper'

module AccountingModule
  module AccountCategories
    describe LevelOneAccountCategory do
      describe 'associations' do 
        it { is_expected.to belong_to :store_front }
        it { is_expected.to have_many :accounts }
        it { is_expected.to have_many :credit_amounts }
        it { is_expected.to have_many :debit_amounts }
        it { is_expected.to have_many :entries }
        it { is_expected.to have_many :credit_entries }
        it { is_expected.to have_many :debit_entries }
      end 

      describe 'validations' do 
        it { is_expected.to validate_presence_of :title }
        it { is_expected.to validate_presence_of :code }
        it { is_expected.to validate_presence_of :type }
        it 'validate_uniqueness_of(:title).scoped_to(:store_front_id)' do 
          store_front         = create(:store_front)
          create(:asset_level_one_account_category, title: 'Cash on Hand', store_front: store_front)
          l1_account_category = build(:asset_level_one_account_category, title: 'Cash on Hand', store_front: store_front)
          l1_account_category.save 

          expect(l1_account_category.errors[:title]).to eql ['has already been taken']
        end 
      end 
    end 
  end 
end
