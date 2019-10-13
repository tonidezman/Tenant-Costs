# == Schema Information
#
# Table name: expenses
#
#  id         :bigint           not null, primary key
#  expense_at :datetime
#  month      :string
#  name       :string
#  value      :decimal(5, 2)
#  year       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_expenses_on_month_and_year  (month,year)
#

# typed: false

require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe '.parse_expense_row' do
    it 'correctly parses raw record data from the scraper'
    it 'raises error if too little elements'
    it 'raises error if to much elements'
    it 'raises error if tenant expense value is positive integer'
    it 'raises error if tenant expense value is zero'
  end

  describe 'expenses are idempotent' do
    it 'correctly saves expenses only once on single run'
    it 'correctly saves expenses only once on multiple runs'
  end
end
