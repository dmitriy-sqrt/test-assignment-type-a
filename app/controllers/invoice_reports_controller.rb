class InvoiceReportsController < ApplicationController
  def index
    @reports = scope.all
  end

  def show
    @report = scope.find(params[:id])
  end

  def new
    build_report
  end

  def create
    result = ::ProcessInvoiceReport.new(
      csv: new_report_csv,
      customer: current_user
    ).call

    if result.success
      redirect_to invoice_report_path(result.object),
        notice: 'Report successfully uploaded'
    else
      build_report
      flash.now[:error] = "Report upload failed: #{result.errors}"
      render :new
    end
  end

  private

  def build_report
    @report = scope.new
  end

  def scope
    InvoiceReport.where(customer_id: current_user.id)
  end

  def new_report_csv
    params.require(:invoice_report).permit(:csv).fetch(:csv)
  end
end
