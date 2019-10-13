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

  def expenses(current_date: DateTime.now.beginning_of_month + 20.days)
    [
      [
        'Bank inc.',
        '12.10.2019',
        'VI-ONLINE CITYPARK, LJUBLJANA',
        '-75,41 EUR'
      ],
      ['Bank inc.', '11.10.2019', 'VI-HOFER hvala, Ljubljana', '-13,04 EUR'],
      ['Bank inc.', '09.10.2019', 'VI-INTERSPAR VIC, LJUBLJANA', '-22,77 EUR'],
      ['Bank inc.', '05.10.2019', 'VI-HOFER hvala, Ljubljana', '-5,74 EUR'],
      ['Bank inc.', '04.10.2019', 'VI-HOFER hvala, Ljubljana', '-50,98 EUR'],
      [
        'Bank inc.',
        '03.10.2019',
        'VI-PE MUELLER COPOVA, LJUBLJANA',
        '-41,59 EUR'
      ],
      [
        'Bank inc.',
        '01.10.2019',
        'VI-LECLERC RUDNIDIS, LJUBLJANA',
        '-84,00 EUR'
      ],
      [
        'Bank inc.',
        '01.10.2019',
        'VI-C & A Ljubljana, Ljubljana',
        '-42,60 EUR'
      ],
      [
        'Bank inc.',
        '01.10.2019',
        'VI-ONLINE CITYPARK, LJUBLJANA',
        '-62,59 EUR'
      ],
      ['Bank inc.', '01.10.2019', 'Obresti pozitivnega stanja', '0,01 EUR'],
      [
        'Bank inc.',
        '30.09.2019',
        'Nad. za vodenje kart.rač. za AC Visa Inspire',
        '-0,10 EUR'
      ],
      [
        'Bank inc.',
        '30.09.2019',
        'Nadomestilo vodenja TRR e-račun',
        '-1,70 EUR'
      ],
      [
        'Bank inc.',
        '30.09.2019',
        'Nadomestilo za uporabo Banke IN',
        '-1,07 EUR'
      ],
      ['VZAJEMNA D.V.Z.', '30.09.2019', 'VZAJEMNA - 480368890', '-34,60 EUR'],
      [
        'Bank inc.',
        '30.09.2019',
        'Plačilna transakcija s SEPA direktno obremenitvijo',
        '-0,33 EUR'
      ],
      [
        'Bank inc.',
        '30.09.2019',
        'Plačilna transakcija s SEPA direktno obremenitvijo',
        '-0,33 EUR'
      ],
      ['VRTEC VISKI GAJ', '30.09.2019', 'OSKRBNINE', '-169,63 EUR'],
      ['Bank inc.', '28.09.2019', 'VI-VERACE 2.0, LJUBLJANA', '-31,50 EUR'],
      ['Bank inc.', '28.09.2019', 'VI-HOFER hvala, Ljubljana', '-4,52 EUR'],
      [
        'Bank inc.',
        '25.09.2019',
        'VI-ALPE PANON PE LJ COPOVA, LJUBLJANA',
        '-11,40 EUR'
      ],
      ['Bank inc.', '25.09.2019', 'VI-SPAR COPOVA, LJUBLJANA', '-2,01 EUR'],
      ['Bank inc.', '24.09.2019', 'VI-HOFER hvala, Ljubljana', '-20,92 EUR'],
      [
        'Bank inc.',
        '24.09.2019',
        'VI-ALPE PANON PE LJ COPOVA, LJUBLJANA',
        '-1,70 EUR'
      ],
      ['MARJETA TURK', '24.09.2019', 'Drugo', '450,78 EUR'],
      [
        'Bank inc.',
        '23.09.2019',
        'VI-ALPE PANON PE LJ COPOVA, LJUBLJANA',
        '-3,40 EUR'
      ],
      [
        'Bank inc.',
        '21.09.2019',
        'VI-V. MESTO ATLANTIS REC., LJUBLJANA',
        '-68,00 EUR'
      ],
      [
        'Bank inc.',
        '21.09.2019',
        'VI-ALPE PANON PE LJ SMARTINS, LJUBLJANA',
        '-7,40 EUR'
      ],
      [
        'Bank inc.',
        '21.09.2019',
        'VI-INTERSPAR CITYPARK LJUBLJ, LJUBLJANA',
        '-13,40 EUR'
      ],
      ['Bank inc.', '19.09.2019', 'VI-Joe Penas, Ljubljana', '-18,10 EUR'],
      ['Bank inc.', '18.09.2019', 'KREDIT-903000823517523', '-218,79 EUR'],
      ['SPL D.D.', '18.09.2019', 'DB SEP 2019', '-103,01 EUR'],
      [
        'Bank inc.',
        '18.09.2019',
        'Plačilna transakcija s SEPA direktno obremenitvijo',
        '-0,33 EUR'
      ],
      ['TELEMACH D.O.O.', '18.09.2019', 'TELEMACH 9014444848085', '-43,00 EUR']
    ]
  end
end
