# == Schema Information
#
# Table name: invoices
#
#  id                :bigint           not null, primary key
#  internal_id       :string
#  due_date          :date
#  amount            :integer
#  price             :float
#  invoice_report_id :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
