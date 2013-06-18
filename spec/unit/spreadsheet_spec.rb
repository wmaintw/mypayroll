# encoding: UTF-8

require "spec_helper"
require "spreadsheet"

describe "Read content from excel file" do

  before do
    @book = Spreadsheet.open Rails.root.join("spec/fixtures/test-payroll.xls")
    @sheet = @book.worksheet 0
  end

  it "should read the first row" do
    row = @sheet.row 0

    row[0].should == "No."
  end

  it "should read each row" do
    count = 0
    @sheet.each do |row|
      count += 1
    end

    count.should == 9
  end

  it "should read each cell of row" do
    row = @sheet.row 2

    row[0].should == 20
    row[1].should == "IS"
    row[2].should == "IS"
    row[3].should == "Sr Associate"
    row[5].should == "马伟"
    row[6].should == "Ma,Wei"
    row[7].to_s.should == "2013-04-04T00:00:00+00:00"
    row[8].to_s.should == "2013-04-01T00:00:00+00:00"
    row[9].to_s.should == ""
    row[9].should be_nil
  end

  it "should read data from each worksheet" do
    @sheet_id = @book.worksheet("ID")
    @sheet_beijing = @book.worksheet("BJ")
    @sheet_xian = @book.worksheet("XA")
    @sheet_chengdu = @book.worksheet("CD")
    @sheet_shanghai = @book.worksheet("SH")

    @sheet_id.column_count.should == 8
    @sheet_beijing.row_count.should > 2
    @sheet_xian.row_count.should > 2
    @sheet_chengdu.row_count.should > 2
    @sheet_shanghai.row_count.should > 2
  end
end