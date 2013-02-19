require 'spreadsheet'

class AdminController < ApplicationController
  def home

  end

  def upload
    Payroll.parse_and_save(params[:file])

    redirect_to "/admin/home"
  end
end
