# coding: utf-8
require 'spec_helper'

describe OrderList do
  before do
    dir = File.expand_path(File.dirname(__FILE__) + "../../../import/spec")
    path = Dir.glob("#{dir}/*").first
    @orderlist = OrderList.new(path)
  end

  describe "#size" do
    it "should be rows of CSV." do
      @orderlist.size.should == 3
    end
  end

  describe "#header" do
    it "should return header row in CSV." do
      @orderlist.header[0].should  == "受注番号"
      @orderlist.header[45].should == "コメント"
    end
  end

  describe "#orders" do
    it "should return order rows in CSV." do
      @orderlist.orders.size.should == 2
    end
  end

  describe "#save_as" do
    it "should be able to save CSV" do
      @orderlist.save_as("spec.csv")
      File.exist?("spec.csv").should == true
    end

    after do
     File.unlink("spec.csv") if File.exist? "spec.csv"
    end
  end
end
