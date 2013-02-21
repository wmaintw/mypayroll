require 'spreadsheet'

class Admin::PayrollController < ApplicationController
  layout "application_admin"

  before_filter :auth

  def new

  end

  def create
    if Payroll.parse_to_database!(params[:file])
      flash[:message] = "Payroll uploaded successfully."
    else
      flash[:message] = "Failed to upload payroll."
    end
    redirect_to new_admin_payroll_path
  end
end
