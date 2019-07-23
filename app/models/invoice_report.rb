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

class InvoiceReport < ApplicationRecord
  has_many :invoices

  validates :csv, presence: true
  validates :customer_id, presence: true
end
