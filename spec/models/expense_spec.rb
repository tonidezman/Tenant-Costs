# == Schema Information
#
# Table name: expenses
#
#  id         :integer          not null, primary key
#  name       :string
#  month      :string
#  year       :string
#  expense_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# typed: false
require 'rails_helper'

RSpec.describe Expense, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
