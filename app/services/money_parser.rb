class MoneyParser
  def self.parse(money_value)
    money = money_value.split(' ').first
    money.gsub('.', '').gsub(',', '.').to_f * 100
  end
end
