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

  describe "#malltype" do
    it "should be Order::Amazon when filename is like 1234567890.txt" do
      @orderlist.loadpath = "/hogehoge/1234567890 (2).txt"
      @orderlist.type.should == Order::Amazon
    end

    it "should be Order::Rakuten when filename is like 20121203 (2).csv" do
      @orderlist.loadpath = "/hogehoge/2012103 (2).csv"
      @orderlist.type.should == Order::Rakuten
    end

    it "should be Order::Yahoo when filename is like default_all_orders.csv" do
      @orderlist.loadpath = "/hogehoge/default_all_orders.csv"
      @orderlist.type.should == Order::Yahoo
    end

    it "should be nil when filename is like default_all_items.csv" do
      @orderlist.loadpath = "/hogehoge/default_all_items.csv"
      @orderlist.type.should == nil
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
