# encoding: UTF-8

require "spec_helper"
require "poi"

describe "Read content from excel file" do

  before do
    @book = POI::Workbook.open(Rails.root.join("spec/fixtures/test-payroll.xls"))
    @sheet = @book.worksheets[0]
  end

  it "should read the first row" do
    @sheet.rows[0][0].value.should == "No."
  end

  it "should read each row" do
    count = 0
    @sheet.rows.each do |row|
      count += 1
    end

    count.should == 9
  end

  it "should read each cell of row" do
    row = @sheet.rows[2]

    row[0].value.should == 20
    row[1].value.should == "IS"
    row[2].value.should == "IS"
    row[3].value.should == "Sr Associate"
    row[5].value.should == "马伟"
    row[6].value.should == "Ma,Wei"
    row[7].value.to_s.should == "2013-04-04"
    row[8].value.to_s.should == "2013-04-01"
    row[9].value.to_s.should == ""
    row[9].value.should be_nil
  end

  it "should read data from each worksheet" do
    @sheet_id = @book.worksheets["ID"]
    @sheet_beijing = @book.worksheets["BJ"]
    @sheet_xian = @book.worksheets["XA"]
    @sheet_chengdu = @book.worksheets["CD"]
    @sheet_shanghai = @book.worksheets["SH"]

    @sheet_beijing.rows.size.should > 2
    @sheet_xian.rows.size.should > 2
    @sheet_chengdu.rows.size.should > 2
    @sheet_shanghai.rows.size.should > 2
  end
end