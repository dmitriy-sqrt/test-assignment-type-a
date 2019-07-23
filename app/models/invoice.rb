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

class Invoice < ApplicationRecord
  belongs_to :invoice_report

  validates :internal_id, presence: true
  validates :due_date, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0}
end
