# == Schema Information
#
# Table name: invoice_reports
#
#  id          :bigint           not null, primary key
#  customer_id :integer
#  summary     :text
#  csv         :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class InvoiceReportTest < ActiveSupport::TestCase
  test 'valid fixture' do
    # TODO: extract to shared helper
    path = Rails.root.join('test/fixtures/files/fully_valid_invoice_report.csv')
    csv = Rack::Test::UploadedFile.new(path)

    report = InvoiceReport.new(customer_id: 1, csv: csv)
    assert report.valid?
  end

  test 'customer is required' do
    report = InvoiceReport.new

    assert_not report.valid?
    assert_not_empty report.errors[:customer_id]
  end

  test 'csv is required' do
    report = InvoiceReport.new

    assert_not report.valid?
    assert_not_empty report.errors[:csv]
  end
end
