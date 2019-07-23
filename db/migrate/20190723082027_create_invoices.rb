class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :internal_id, nil: false
      t.date :due_date, nil: false
      t.integer :amount, nil: false
      t.float :price
      t.belongs_to :invoice_report, foreign_key: true

      t.timestamps
    end
  end
end
