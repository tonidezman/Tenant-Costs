# typed: false

require 'rails_helper'

RSpec.describe MoneyParser, type: :model do
  context 'negative money values' do
    it '-0,33 EUR' do
      expect(MoneyParser.parse('-0,33 EUR')).to eq(-0.33)
    end

    it '-99,33' do
      expect(MoneyParser.parse('-99,33 EUR')).to eq(-99.33)
    end

    it '-3.000,99' do
      expect(MoneyParser.parse('-3.000,99 EUR')).to eq(-3_000.99)
    end
  end

  context 'positive money values' do
    it '0,33 EUR' do
      expect(MoneyParser.parse('0,33 EUR')).to eq(0.33)
    end

    it '99,33' do
      expect(MoneyParser.parse('99,33 EUR')).to eq(99.33)
    end

    it '3.000,99' do
      expect(MoneyParser.parse('3.000,99 EUR')).to eq(3_000.99)
    end
  end
end
