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
    it 'correctly parses raw record data from the scraper' do
      expect { Expense.parse_expense_row(raw_expenses) }.not_to raise_error(
                      InvalidExpense
                    )
    end

    it 'converts raw expense data to Expense objects' do
      expect(
        Expense.parse_expense_row(raw_expenses).all? { |expense|
          expense.is_a? Expense
        }
      ).to be true
    end

    it 'saves expense only once (idempotent) on multiple runs' do
    end

    it 'gets back only valid tenant expenses' do
      expenses = Expense.parse_expense_row(raw_expenses)
      counter = 0
      expenses.each { |expense| counter += 1 if expense.valid? }
      expect(counter).to eq(4)
    end

    it 'raises error if too little elements' do
    end

    it 'raises error if to much elements' do
    end

    it 'raises error if tenant expense value is positive integer' do
    end

    it 'raises error if tenant expense value is zero' do
    end
  end

  describe 'expenses are idempotent' do
    it 'correctly saves expenses only once on single run'
    it 'correctly saves expenses only once on multiple runs'
  end

  def raw_date(days_ago, current_date: nil)
    if current_date.nil?
      current_date = DateTime.now.beginning_of_month + 20.days
    end
    (current_date - days_ago).strftime('%d.%m.%Y')
  end

  def raw_expenses
    [
      ['Bank inc.', raw_date(0.days), 'some text', '-75,41 EUR'],
      ['Bank inc.', raw_date(1.days), 'some text', '-13,04 EUR'],
      ['Bank inc.', raw_date(2.days), 'some text', '-22,77 EUR'],
      ['Bank inc.', raw_date(3.days), 'some text', '-5,74 EUR'],
      ['Bank inc.', raw_date(4.days), 'some text', '-50,98 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-41,59 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-84,00 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-42,60 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-62,59 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '0,01 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-0,10 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-1,70 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-1,07 EUR'],
      ['VZAJEMNA', raw_date(5.days), 'some text', '-34,60 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-0,33 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-0,33 EUR'],
      ['VRTEC', raw_date(5.days), 'OSKRBNINE', '-169,63 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-31,50 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-4,52 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-11,40 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-2,01 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-20,92 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-1,70 EUR'],
      ['MARY SMITH', raw_date(5.days), 'Drugo', '450,78 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-3,40 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-68,00 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-7,40 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-13,40 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-18,10 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-218,79 EUR'],
      ['SPL D.D.', raw_date(5.days), 'DB SEP 2019', '-103,01 EUR'],
      ['Bank inc.', raw_date(5.days), 'some text', '-0,33 EUR'],
      ['TELEMACH D.O.O.', raw_date(2.days), 'some text', '-43,00 EUR'],
      ['GEN-I, D.O.O.', raw_date(2.days), 'some text', '-52,00 EUR'],
      ['RTV SLOVENIJA', raw_date(3.days), 'some text', '-12,75 EUR']
    ]
  end
end
