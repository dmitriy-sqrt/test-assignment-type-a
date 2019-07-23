require 'csv'

class ProcessInvoiceReport < BaseService
  class InvoiceRow
    attr_reader :internal_id, :row_number

    # TODO: ask business to add csv headers for easier parsing
    def initialize(row:, row_number:)
      @row_number = row_number
      @internal_id, @amount, @due_date = row.values_at(0,1,2)
    end

    def due_date
      Date.strptime(@due_date, '%Y-%m-%d') rescue nil
    end

    def amount
      @amount.to_i
    end

    def valid?
      errors.blank?
    end

    def errors
      @errors ||= begin
        errors = []
        errors << 'Internal id is missing' unless internal_id.present?
        errors << 'Amount is missing or invalid' unless amount_valid?
        errors << 'Due date is missing or invalid' unless due_date.present?
        errors.join(',')
      end
    end

    private

    def amount_valid?
      amount > 0
    end
  end

  def initialize(csv:, customer:)
    @csv = csv
    @customer = customer
    @summary = ''
  end

  def call
    create_invoice_report
    process_csv_rows
    save_report_summary

    return Result.new(success: true, object: @invoice_report)
  rescue StandardError => e
    return Result.new(success: false, errors: e)
  end

  private

  def process_csv_rows
    csv = CSV.new(@invoice_report.csv.read, headers: false)

    csv.each_with_index do |row, number|
      process_row(row: row, number: number)
    end
  end

  def process_row(row:, number:)
    return if row.blank?

    processed_row = InvoiceRow.new(row: row, row_number: number)

    if processed_row.valid?
      create_invoice(row: processed_row)
    else
      record_errors(row: processed_row, errors: processed_row.errors)
    end
  end

  def create_invoice(row:)
    invoice = Invoice.find_or_initialize_by(
      internal_id: row.internal_id,
      due_date: row.due_date,
      amount: row.amount,
      invoice_report: @invoice_report
    )

    if invoice.new_record? && invoice.valid?
      invoice.save!
    else
      record_errors(row: row, errors: invoice.errors.full_messages.join(','))
    end
  end

  def record_errors(row:, errors:)
    @summary << "Row ##{row.row_number} has errors: #{errors}\n"
  end

  def create_invoice_report
    @invoice_report = InvoiceReport.create!(
      customer_id: @customer.id,
      csv: @csv
    )
  end

  def save_report_summary
    @invoice_report.update!(summary: @summary)
  end
end
