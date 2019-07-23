class CreateInvoiceReports < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_reports do |t|
      t.integer :customer_id, nil: false
      t.text :summary
      t.string :csv, nil: false

      t.timestamps
    end
  end
end
