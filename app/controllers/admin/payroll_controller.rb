require 'spreadsheet'

class Admin::PayrollController < ApplicationController
  layout "application_admin"

  before_filter :auth_admin

  def new

  end

  def create
    if Payroll.parse_to_database!(params[:file], parse_payroll_month())
      flash[:message] = "Payroll uploaded successfully."
    else
      flash[:message] = "Failed to upload payroll."
    end
    redirect_to new_admin_payroll_path
  end

  def parse_payroll_month
    "#{params[:date][:year]}-#{params[:date][:month]}-01"
  end
end
