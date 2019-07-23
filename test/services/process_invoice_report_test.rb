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
        csv = CSV.new('invalid csv', headers: false)
        @row = ProcessInvoiceReport::InvoiceRow.new(row: csv.first, row_number: 1)
      end

      it 'is invalid with faulty data' do
        @row.valid?.must_equal false
      end
    end

    describe 'valid' do
      before do
        csv = CSV.new('B,300,2019-05-01', headers: false)
        @row = ProcessInvoiceReport::InvoiceRow.new(row: csv.first, row_number: 1)
      end

      it 'is valid with correct data' do
        @row.valid?.must_equal true
      end
    end
  end

  context 'processing' do
    describe 'with all valid invoices' do
      before do
        csv = '1,100,2019-05-20
               2,200.5,2019-05-10
               B,300,2019-05-01'

        @result = ProcessInvoiceReport.new(csv: csv, customer: OpenStruct.new(id: 1)).call
      end

      it 'creates report and imports all invoices' do
        InvoiceReport.count.must_equal 1
        Invoice.count.must_equal 3
      end
    end

    describe 'with 2 valid invoices' do
      before do
        csv = '1,100,2019-05-20
               2,invalid,2019-05-10
               B,,'

        @result = ProcessInvoiceReport.new(csv: csv, customer: OpenStruct.new(id: 1)).call
      end

      it 'creates report and imports valid invoices' do
        InvoiceReport.count.must_equal 1
        Invoice.count.must_equal 1
      end
    end
  end
end
