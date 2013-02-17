# encoding: UTF-8

require "spec_helper"
require "spreadsheet"

describe "Read content from excel file" do

  before do
    @book = Spreadsheet.open Rails.root.join("spec/data/test-payroll.xls")
    @sheet = @book.worksheet 0
  end

  it "should read the first row" do
    row = @sheet.row 0

    row[0].should == "No."
  end

  it "should read each row" do
    count = 0
    @sheet.each do |row|
      row[0].to_s.length.should > 0
      count += 1
    end

    count.should == 5
  end

  it "should read each cell of row" do
    row = @sheet.row 2

    row[0].should == 18
    row[1].should == "PS"
    row[2].should == "Developer"
    row[3].should == "Consultant"
    row[4].should == "马伟"
    row[5].should == "Ma,Wei"
    row[6].to_s.should == "2012-11-12"
    row[7].to_s.should == "2012-04-05"
    row[8].to_s.should == ""

    for index in 9..(row.count - 1)
      row[index].should >= 1000
    end
  end
end