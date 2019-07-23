class InvoiceReportsController < ApplicationController
  def index
    @reports = scope.all
  end

  def show
    @report = scope.find(params[:id])
  end

  def new
    @report = scope.new
  end

  def create

  end

  private

  def scope
    InvoiceReport.where(customer_id: current_user.id)
  end
end
