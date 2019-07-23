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
  test 'early upload' do
    due_date_for_early = (Invoice::EARLY_UPLOAD_INTERVAL + 10.days).from_now
    setup_invoice(due_date: due_date_for_early)

    assert_equal @invoice.price, Invoice::EARLY_COEFFICIENT
  end

  test 'standard upload' do
    setup_invoice(due_date: Date.today)

    assert_equal @invoice.price, Invoice::STANDARD_COEFFICIENT
  end

  private

  def setup_invoice(due_date:)
    @invoice = Invoice.new(due_date: due_date, amount: 1)
    @invoice.save(validate: false)
  end
end
