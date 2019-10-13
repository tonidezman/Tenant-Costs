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

# typed: strong

class Expense < ApplicationRecord; end
