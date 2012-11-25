# coding: utf-8
require 'spec_helper'

describe Order::Amazon do
  before do
    arr = []
    arr[63] = ""
    @order = Order::Amazon.new(arr)
  end

  describe "Accessors for optional attribute" do
    it "arr" do
      @order.arr = ["123", "456"]
      @order.arr.size.should == 2
    end

    it "status" do
      @order.status = "ロジテム"
      @order.status.should == "ロジテム"
    end

    it "shipping_date" do
      @order.shipping_date = "2012/11/1"
      @order.shipping_date.should == "2012/11/1"
    end

    it "delivery_date" do
      @order.delivery_date = "2012/11/2"
      @order.delivery_date.should == "2012/11/2"
    end

    it "carrier" do
      @order.carrier = "ヤマト運輸"
      @order.carrier.should == "ヤマト運輸"
    end

    it "delivery_time" do
      @order.delivery_time = "12:00-14:00"
      @order.delivery_time.should == "12:00-14:00"
    end

    it "notes" do
      @order.notes = "備考欄"
      @order.notes.should == "備考欄"
    end

    it "domestic_notes" do
      @order.domestic_notes = "社内備考"
      @order.domestic_notes.should == "社内備考"
    end

    it "warning" do
      @order.warning = "警告\n"
      @order.warning.should == "警告\n"
    end
  end

  describe "#order_datetime" do
    it "should return DateTime." do
      @order.arr[3] = "2012-10-30T01:26:24+00:00"
      @order.order_datetime.should == DateTime.new(2012, 10, 30, 10, 26, 24)
      @order.arr[3] = "2012-11-01T04:48:41+00:00"
      @order.order_datetime.should == DateTime.new(2012, 11, 1, 13, 48, 41)
    end
  end

  describe "#title" do
    it "should return title of item." do
      @order.arr[8] = "商品名"
      @order.title.should == "商品名"
    end
  end

  describe "#zipcode" do
    it "should be zipcode like 123-4567" do
      @order.arr[22] = "012-0345"
      @order.zipcode.should == "012-0345"
    end
  end

  describe "#pref" do
    it "should return prefecture." do
      @order.arr[21] = "東京都"
      @order.pref.should == "東京都"
    end
  end

  describe "#payment_method" do
    it "should be card" do 
      @order.arr[40] = ""
      @order.payment_method.should == :card
    end
  end

  describe "#wish_date" do
    it "should be nil." do 
      @order.wish_date.should == nil
    end
  end

  describe "#wish_time" do
    it "should be nil" do
      @order.wish_time.should == nil
    end
  end

  describe "#demand" do
    it "should be nil" do
      @order.demand.should == nil
    end
  end
end
