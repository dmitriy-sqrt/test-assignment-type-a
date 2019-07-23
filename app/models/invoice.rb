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

  before_save :calculate_price, on: :create

  # TODO: extract to helper class/module
  EARLY_UPLOAD_INTERVAL = 30.days
  EARLY_COEFFICIENT = 0.5
  STANDARD_COEFFICIENT = 0.3

  def calculate_price
    self.price = amount * price_coefficient
  end

  private

  def price_coefficient
    early_upload = Date.today < (due_date - EARLY_UPLOAD_INTERVAL)
    coefficient = early_upload ? EARLY_COEFFICIENT : STANDARD_COEFFICIENT
  end
end
