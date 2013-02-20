require 'spreadsheet'

class AdminController < ApplicationController
  def home

  end

  def upload
    if Payroll.parse_to_database!(params[:file])
      flash[:message] = "Payroll uploaded successfully."
    else
      flash[:message] = "Failed to upload payroll."
    end
    redirect_to "/admin/home"
  end
end
