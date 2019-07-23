require 'test_helper'
require 'minitest/autorun'
require 'shoulda/context'

# TODO: read on minitest and refactor + DRY, this can be much better
describe ProcessInvoiceReport do
  context 'row validation' do
    # TODO: Extract to helper
    before :each do
      DatabaseCleaner.start
    end

    after :each do
      DatabaseCleaner.clean
    end

    describe 'invalid' do
      before do
        @row = prepare_row('invalid csv')
      end

      it 'is invalid with faulty data' do
        @row.valid?.must_equal false
      end
    end

    describe 'valid' do
      before do
        @row = prepare_row('B,300,2019-05-01')
      end

      it 'is valid with correct data' do
        @row.valid?.must_equal true
      end
    end
  end

  context 'processing' do
    describe 'with all valid invoices' do
      before do
        @result = process_report('fully_valid_invoice_report.csv')
      end

      it 'creates report and imports all invoices' do
        InvoiceReport.count.must_equal 1
        Invoice.count.must_equal 3
      end
    end

    describe 'with 2 valid invoices' do
      before do
        @result = process_report('partially_valid_invoice_report.csv')
      end

      it 'creates report and imports valid invoices' do
        InvoiceReport.count.must_equal 1
        Invoice.count.must_equal 1
      end
    end
  end

  private

  def prepare_row(data)
    csv = CSV.new(data, headers: false)
    ProcessInvoiceReport::InvoiceRow.new(row: csv.first, row_number: 1)
  end

  def process_report(csv_path)
    # TODO: extract to shared helper
    path = Rails.root.join('test/fixtures/files', csv_path)
    csv = Rack::Test::UploadedFile.new(path)

    ProcessInvoiceReport.new(csv: csv, customer: OpenStruct.new(id: 1)).call
  end
end
